//
//  CellService.swift
//  App
//
//  Created by 翟泉 on 2019/5/14.
//

import Foundation
import CKB
import SQLite

class CellService {
    struct ValidInputs {
        let cellInputs: [CellInput]
        let capacity: Decimal
    }

    private var currentBlockNumber: Int = 0
    private var api: APIClient!
    private var lockHash: H256!
    private var publicKey: H256!

    init(lockHash: H256, publicKey: H256, api: APIClient) {
        self.lockHash = lockHash
        self.publicKey = publicKey
        self.api = api
        currentBlockNumber = CellService.readBlockNumber(for: lockHash)
    }

    public func gatherInputs(capacity: Decimal) throws -> ValidInputs {
        let sequence = try getUnspentCells()
        var inputCapacities: Decimal = 0
        var inputs = [CellInput]()
        for cell in sequence {
            let input = CellInput(previousOutput: cell.outPoint, args: [], since: "0")
            inputs.append(input)
            inputCapacities += Decimal(string: cell.capacity) ?? 0
            if inputCapacities > capacity {
                currentBlockNumber = getBlockNumber(for: cell.outPoint)
                CellService.saveBlockNumber(currentBlockNumber, for: lockHash)
                break
            }
        }
        guard inputCapacities > capacity else {
            throw Error.notEnoughCapacity(required: "\(capacity)", available: "\(inputCapacities)")
        }
        return ValidInputs(cellInputs: inputs, capacity: inputCapacities)
    }

    private func getBlockNumber(for outPoint: OutPoint) -> Int {
        if let blockHash = outPoint.blockHash {
            if let block = try? api.getBlock(hash: blockHash) {
                return Int(block.header.number)!
            }
        }
        return currentBlockNumber
    }
}

extension CellService {
    private static let connection = try! Connection(.uri(FileManager.default.currentDirectoryPath + "/block_number.db"))
    private static let table = createTable()
    private static let lockHashColumn = Expression<String>("lockHash")
    private static let blockNumberColumn = Expression<Int>("block_number")

    private static func createTable() -> Table {
        let table = Table("block_number")
        try? connection.run(table.create { t in
            t.column(lockHashColumn, primaryKey: true)
            t.column(blockNumberColumn)
        })
        return table
    }

    static func saveBlockNumber(_ blockNumber: Int, for lockHash: H256) {
        do {
            try connection.run(table.insert(
                lockHashColumn <- lockHash,
                blockNumberColumn <- blockNumber
            ))
        } catch {
            let filterResult = table.filter(lockHashColumn == lockHash)
            try! connection.run(filterResult.update(
                lockHashColumn <- lockHash,
                blockNumberColumn <- blockNumber
            ))
        }
    }

    static func readBlockNumber(for lockHash: H256) -> Int {
        let filterResult = table.filter(lockHashColumn == lockHash)
        guard let row = try? connection.prepare(filterResult).first(where: { _ in true }) else { return 1 }
        return row[blockNumberColumn]
    }
}

extension CellService {
    typealias Element = CellOutputWithOutPoint

    struct UnspentCellsIterator: IteratorProtocol {
        let api: APIClient
        let lockHash: H256
        var fromBlockNumber: Int
        let tipBlockNumber: Int
        var cells = [CellOutputWithOutPoint]()

        public init(api: APIClient, lockHash: H256, fromBlockNumber: Int = 1) throws {
            self.api = api
            self.lockHash = lockHash
            self.fromBlockNumber = fromBlockNumber
            tipBlockNumber = Int(try api.getTipBlockNumber())!
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
