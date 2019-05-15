//
//  CellService.swift
//  App
//
//  Created by 翟泉 on 2019/5/14.
//

import Foundation
import CKB
import SQLite3

struct UnspentCell {
    let capacity: Decimal
    let blockHash: H256
    let txHash: H256
    let index: Number
}

class CellService {
    struct ValidInputs {
        let cellInputs: [CellInput]
        let capacity: Decimal
    }

    private var currentBlockNumber: UInt = 0
    private var api: APIClient!
    private var lockHash: H256!
    private var pubkey: H256!

    init(lockHash: H256, pubkey: H256, api: APIClient) {
        self.lockHash = lockHash
        self.pubkey = pubkey
        self.api = api
    }

    public func gatherInputs(capacity: Decimal) throws -> ValidInputs {
        let sequence = try getUnspentCells()
        var inputCapacities: Decimal = 0
        var inputs = [CellInput]()
        for cell in sequence {
            let input = CellInput(previousOutput: cell.outPoint, args: [pubkey], since: "0")
            inputs.append(input)
            inputCapacities += Decimal(string: cell.capacity) ?? 0
            if inputCapacities > capacity {
                break
            }
        }
        guard inputCapacities > capacity else {
            throw WalletError.notEnoughCapacity(required: "\(capacity)", available: "\(inputCapacities)")
        }
        return ValidInputs(cellInputs: inputs, capacity: inputCapacities)
    }


    // MARK:

    func saveBlockNumber(for outPoint: OutPoint) {
        guard let blockHash = outPoint.blockHash else { return }
        guard let block = try? api.getBlock(hash: blockHash) else { return }
        currentBlockNumber = UInt(block.header.number) ?? currentBlockNumber
    }

    func readBlockNumber() -> UInt {
        return 1
    }

    var fileUrl: URL {
        var url = URL(fileURLWithPath: ProcessInfo().arguments[0])
        url.deleteLastPathComponent()
        url.appendPathComponent("block_number")
        return url
    }
}

extension CellService {
    typealias Element = CellOutputWithOutPoint

    struct UnspentCellsIterator: IteratorProtocol {
        let api: APIClient
        let lockHash: H256
        var fromBlockNumber: UInt
        let tipBlockNumber: UInt
        var cells = [CellOutputWithOutPoint]()

        public init(api: APIClient, lockHash: H256, fromBlockNumber: UInt = 1) throws {
            self.api = api
            self.lockHash = lockHash
            self.fromBlockNumber = fromBlockNumber
            tipBlockNumber = UInt(try api.getTipBlockNumber())!
        }

        mutating public func next() -> CellOutputWithOutPoint? {
            guard cells.count == 0 else {
                return cells.removeFirst()
            }
            while fromBlockNumber <= tipBlockNumber {
                let toBlockNumber = min(fromBlockNumber + 100, tipBlockNumber)
                defer {
                    fromBlockNumber = toBlockNumber + 1
                }
                if var cells = try? api.getCellsByLockHash(lockHash: lockHash, from: "\(fromBlockNumber)", to: "\(toBlockNumber)"), cells.count > 0 {
                    defer {
                        self.cells = cells
                    }
                    return cells.removeFirst()
                }
            }
            return nil
        }
    }

    func getUnspentCells() throws -> IteratorSequence<UnspentCellsIterator> {
        return IteratorSequence(try UnspentCellsIterator(api: api, lockHash: lockHash, fromBlockNumber: currentBlockNumber))
    }
}
