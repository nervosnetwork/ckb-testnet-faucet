//
//  Account.swift
//  App
//
//  Created by 翟泉 on 2019/3/29.
//

import Foundation
import CKB

let minCellCapacity: Capacity = 40

class Wallet {
    let api: APIClient
    let privateKey: String

    var deps: [OutPoint] {
        return [systemScriptOutPoint]
    }
    var publicKey: H256 {
        return "0x" + Utils.privateToPublic(privateKey)
    }
    var lock: Script {
        return Script.verifyScript(for: publicKey, binaryHash: systemScriptCellHash)
    }
    var lockHash: H256 {
        return lock.typeHash
    }

    let systemScriptOutPoint: OutPoint
    let systemScriptCellHash: H256

    init(api: APIClient, privateKey: H256) throws {
        self.api = api
        self.privateKey = privateKey

        systemScriptCellHash = try api.systemScriptCellHash()
        systemScriptOutPoint = try api.systemScriptOutPoint()
    }

    func getBalance() throws -> Capacity {
        return try getUnspentCells().reduce(0, { $0 + $1.capacity })
    }

    public func sendCapacity(targetLock: Script, capacity: Capacity) throws -> H256 {
        let tx = try generateTransaction(targetLock: targetLock, capacity: capacity)
        return try api.sendTransaction(transaction: tx)
    }

    // MARK: Utils

    struct ValidInputs {
        let cellInputs: [CellInput]
        let capacity: Capacity
    }

    func gatherInputs(capacity: Capacity, minCapacity: Capacity = minCellCapacity) throws -> ValidInputs {
        guard capacity > minCapacity else {
            throw WalletError.tooLowCapacity(min: minCapacity)
        }
        var inputCapacities: Capacity = 0
        var inputs = [CellInput]()
        for cell in try getUnspentCells() {
            let input = CellInput(previousOutput: cell.outPoint, args: [publicKey])
            inputs.append(input)
            inputCapacities += cell.capacity
            if inputCapacities - capacity >= minCapacity {
                break
            }
        }
        guard inputCapacities > capacity else {
            throw WalletError.notEnoughCapacity(required: capacity, available: inputCapacities)
        }
        return ValidInputs(cellInputs: inputs, capacity: inputCapacities)
    }

    func generateTransaction(targetLock: Script, capacity: Capacity) throws -> Transaction {
        let validInputs = try gatherInputs(capacity: capacity, minCapacity: minCellCapacity)
        var outputs: [CellOutput] = [
            CellOutput(capacity: capacity, data: "0x", lock: targetLock, type: nil)
        ]
        if validInputs.capacity > capacity {
            outputs.append(CellOutput(capacity: validInputs.capacity - capacity, data: "0x", lock: lock, type: nil))
        }
        return Transaction(deps: deps, inputs: validInputs.cellInputs, outputs: outputs, hash: privateKey)
    }
}

extension Wallet {
    typealias Element = CellOutputWithOutPoint

    public struct UnspentCellsIterator: IteratorProtocol {
        let api: APIClient
        let lockHash: H256
        var fromBlockNumber: BlockNumber
        let tipBlockNumber: BlockNumber
        var cells = [CellOutputWithOutPoint]()

        public init(api: APIClient, lockHash: H256) throws {
            self.api = api
            self.lockHash = lockHash
            fromBlockNumber = 1
            tipBlockNumber = try api.getTipBlockNumber()
        }

        mutating public func next() -> CellOutputWithOutPoint? {
            guard cells.count == 0 else {
                return cells.removeFirst()
            }
            while fromBlockNumber <= tipBlockNumber {
                let toBlockNumber = min(fromBlockNumber + 800, tipBlockNumber)
                defer {
                    fromBlockNumber = toBlockNumber + 1
                }
                if var cells = try? api.getCellsByLockHash(lockHash: lockHash, from: fromBlockNumber, to: toBlockNumber), cells.count > 0 {
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
        return IteratorSequence(try UnspentCellsIterator(api: api, lockHash: lockHash))
    }
}

enum WalletError: LocalizedError {
    case tooLowCapacity(min: Capacity)
    case notEnoughCapacity(required: Capacity, available: Capacity)

    var localizedDescription: String {
        switch self {
        case .tooLowCapacity(let min):
            return "Capacity cannot less than \(min)"
        case .notEnoughCapacity(let required, let available):
            return "Not enough capacity, required: \(required), available: \(available)"
        }
    }
}
