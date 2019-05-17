//
//  Account.swift
//  App
//
//  Created by 翟泉 on 2019/3/29.
//

import Foundation
import CKB

let minCellCapacity = Decimal(60 * pow(10, 8))

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

    private var cellService: CellService!

    public init(api: APIClient, systemScript: SystemScript, privateKey: H256) {
        self.api = api
        self.systemScript = systemScript
        self.privateKey = privateKey
        cellService = CellService(lockHash: lockHash, publicKey: publicKey, api: api)
    }

    public func getBalance() throws -> Decimal {
        return try cellService.getUnspentCells().reduce(0, { $0 + Decimal(string: $1.capacity)! })
    }

    public func sendCapacity(targetLock: Script, capacity: Decimal) throws -> H256 {
        guard capacity >= minCellCapacity else { throw Error.tooLowCapacity(min: minCellCapacity.description) }
        let tx = try generateTransaction(targetLock: targetLock, capacity: capacity)
        return try api.sendTransaction(transaction: tx)
    }

    // MARK: Utils

    func generateTransaction(targetLock: Script, capacity: Decimal) throws -> Transaction {
        let validInputs = try cellService.gatherInputs(capacity: capacity)
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
    enum Error: LocalizedError {
        case tooLowCapacity(min: Capacity)

        var localizedDescription: String {
            switch self {
            case .tooLowCapacity(let min):
                return "Capacity cannot less than \(min)"
            }
        }
    }
}


