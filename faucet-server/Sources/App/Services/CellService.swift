//
//  CellService.swift
//  App
//
//  Created by 翟泉 on 2019/5/14.
//

import Foundation
import CKB

public class CellService {
    public struct ValidInputs {
        let cellInputs: [CellInput]
        let capacity: Capacity
    }

    private var currentBlockNumber: UInt64 = 0
    private var api: APIClient!
    private var lockHash: H256

    init(lock: Script, api: APIClient) {
        self.api = api
        lockHash = lock.hash
        currentBlockNumber = CellService.readBlockNumber(for: lockHash)
    }

    public func gatherInputs(capacity: Capacity) throws -> ValidInputs {
        let sequence = try getUnspentCells()
        var inputCapacities: Capacity = 0
        var inputs = [CellInput]()
        for (cell, blockNumber) in sequence {
            let input = CellInput(previousOutput: cell.outPoint, since: 0)
            inputs.append(input)
            inputCapacities += cell.capacity
            if inputCapacities > capacity {
                currentBlockNumber = blockNumber
                CellService.saveBlockNumber(currentBlockNumber, for: lockHash)
                break
            }
        }
        guard inputCapacities > capacity else {
            throw Error.notEnoughCapacity(required: capacity, available: inputCapacities)
        }
        return ValidInputs(cellInputs: inputs, capacity: inputCapacities)
    }
}

/// Data store
extension CellService {
    private static let savePath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath + "/block_number")

    public static func saveBlockNumber(_ blockNumber: UInt64, for lockHash: H256) {
        var blockNumberOfLockHash: [String: UInt64]
        do {
            let data = try Data(contentsOf: savePath)
            blockNumberOfLockHash = try JSONDecoder().decode([String: UInt64].self, from: data)
        } catch {
            blockNumberOfLockHash = [:]
        }
        blockNumberOfLockHash[lockHash] = blockNumber
        try? JSONEncoder().encode(blockNumberOfLockHash).write(to: savePath)
    }

    public static func readBlockNumber(for lockHash: H256) -> UInt64 {
        do {
            let data = try Data(contentsOf: savePath)
            let blockNumberOfLockHash = try JSONDecoder().decode([String: UInt64].self, from: data)
            return blockNumberOfLockHash[lockHash] ?? 1
        } catch {
            return 1
        }
    }
}

extension CellService {
    typealias FromBlockNumber = UInt64
    typealias Element = (CellOutputWithOutPoint, FromBlockNumber)

    struct UnspentCellsIterator: IteratorProtocol {
        let api: APIClient
        let lockHash: H256
        var fromBlockNumber: UInt64
        let tipBlockNumber: UInt64
        var cells = [CellOutputWithOutPoint]()

        public init(api: APIClient, lockHash: H256, fromBlockNumber: UInt64 = 1) throws {
            self.api = api
            self.lockHash = lockHash
            self.fromBlockNumber = fromBlockNumber
            tipBlockNumber = try api.getTipBlockNumber()
        }

        mutating public func next() -> Element? {
            guard cells.count == 0 else {
                return (cells.removeFirst(), fromBlockNumber)
            }
            while fromBlockNumber <= tipBlockNumber {
                let toBlockNumber = min(fromBlockNumber + 100, tipBlockNumber)
                defer {
                    fromBlockNumber = toBlockNumber + 1
                }
                if var cells = try? api.getCellsByLockHash(lockHash: lockHash, from: fromBlockNumber, to: toBlockNumber), cells.count > 0 {
                    defer {
                        self.cells = cells
                    }
                    return (cells.removeFirst(), fromBlockNumber)
                }
            }
            return nil
        }
    }

    func getUnspentCells() throws -> IteratorSequence<UnspentCellsIterator> {
        return IteratorSequence(try UnspentCellsIterator(api: api, lockHash: lockHash, fromBlockNumber: currentBlockNumber))
    }
}

extension CellService {
    enum Error: LocalizedError {
        case notEnoughCapacity(required: Capacity, available: Capacity)

        var localizedDescription: String {
            switch self {
            case .notEnoughCapacity(let required, let available):
                return "Not enough capacity, required: \(required), available: \(available)"
            }
        }
    }
}
