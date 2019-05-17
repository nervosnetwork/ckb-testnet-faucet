//
//  Account.swift
//  App
//
//  Created by 翟泉 on 2019/3/29.
//

import Foundation
import CKB
import Vapor

let minCellCapacity = Decimal(floatLiteral: 42 * pow(10, 8))

public class Wallet {
    let api: APIClient
    let privateKey: String
    let systemScript: SystemScript

    var deps: [OutPoint] {
        return [systemScript.outPoint]
    }
    var publicKey: H256 {
        return "0x" + Utils.privateToPublic(privateKey)
    }
    var address: String {
        return AddressGenerator(network: .testnet).address(for: publicKey)
    }
    var publicKeyHash: String {
        return "0x" + AddressGenerator(network: .testnet).hash(for: Data(hex: publicKey)).toHexString()
    }
    public var lock: Script {
        return Script(args: [publicKeyHash], codeHash: systemScript.codeHash)
    }
    var lockHash: H256 {
        return lock.hash
    }

    public init(api: APIClient, systemScript: SystemScript, privateKey: H256) {
        self.api = api
        self.systemScript = systemScript
        self.privateKey = privateKey
    }

    public func getBalance() throws -> Decimal {
        return try getUnspentCells().reduce(0, { $0 + Decimal(string: $1.capacity)! })
    }

    public func sendCapacity(targetLock: Script, capacity: Decimal) throws -> H256 {
        let tx = try generateTransaction(targetLock: targetLock, capacity: capacity)
        return try api.sendTransaction(transaction: tx)
    }

    // MARK: Utils

    struct ValidInputs {
        let cellInputs: [CellInput]
        let capacity: Decimal
    }

    func gatherInputs(capacity: Decimal, minCapacity: Decimal = minCellCapacity) throws -> ValidInputs {
        guard capacity > minCapacity else {
            throw WalletError.tooLowCapacity(min: "\(minCapacity)")
        }
        var inputCapacities: Decimal = 0
        var inputs = [CellInput]()
        for cell in try getUnspentCells() {
            let input = CellInput(previousOutput: cell.outPoint, args: [publicKey], since: "0")
            inputs.append(input)
            inputCapacities += Decimal(string: cell.capacity) ?? 0
            if inputCapacities - capacity >= minCapacity {
                break
            }
        }
        guard inputCapacities > capacity else {
            throw WalletError.notEnoughCapacity(required: "\(capacity)", available: "\(inputCapacities)")
        }
        return ValidInputs(cellInputs: inputs, capacity: inputCapacities)
    }

    func generateTransaction(targetLock: Script, capacity: Decimal) throws -> Transaction {
        let validInputs = try gatherInputs(capacity: capacity, minCapacity: minCellCapacity)
        var outputs: [CellOutput] = [
            CellOutput(capacity: "\(capacity)", data: "0x", lock: targetLock, type: nil)
        ]
        if validInputs.capacity > capacity {
            outputs.append(CellOutput(capacity: "\(validInputs.capacity - capacity)", data: "0x", lock: lock, type: nil))
        }
        let tx = Transaction(deps: deps, inputs: validInputs.cellInputs, outputs: outputs)
        let txhash = try api.computeTransactionHash(transaction: tx)
        return Transaction.sign(tx: tx, with: Data(hex: privateKey), txHash: txhash)
    }
}

extension Wallet {
    typealias Element = CellOutputWithOutPoint

    public struct UnspentCellsIterator: IteratorProtocol {
        let api: APIClient
        let lockHash: H256
        var fromBlockNumber: UInt
        let tipBlockNumber: UInt
        var cells = [CellOutputWithOutPoint]()

        public init(api: APIClient, lockHash: H256) throws {
            self.api = api
            self.lockHash = lockHash
            fromBlockNumber = 1
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
