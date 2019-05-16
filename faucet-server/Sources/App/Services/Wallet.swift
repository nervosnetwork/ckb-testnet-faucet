//
//  Account.swift
//  App
//
//  Created by 翟泉 on 2019/3/29.
//

import Foundation
import CKB

let minCellCapacity = Decimal(floatLiteral: 42 * pow(10, 8))

public class Wallet {
    let api: APIClient
    let privateKey: String

    var deps: [OutPoint] {
        return [systemScriptOutPoint]
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
        return Script(args: [publicKeyHash], codeHash: systemScriptCellHash)
    }
    var lockHash: H256 {
        return lock.typeHash
    }

    var systemScriptOutPoint: OutPoint!
    var systemScriptCellHash: H256!

    private var cellService: CellService!

    public init(api: APIClient, privateKey: H256) throws {
        self.api = api
        self.privateKey = privateKey

        let blockHash = try api.getBlockHash(number: "0")
        let transaction = try api.genesisBlock().transactions[0]
        let cellData = Data(hex: transaction.outputs[0].data)
        systemScriptCellHash = Utils.prefixHex(Blake2b().hash(data: cellData)!.toHexString())
        systemScriptOutPoint = OutPoint(blockHash: blockHash, cell: CellOutPoint(txHash: transaction.hash, index: "0"))
        cellService = CellService(lockHash: lockHash, publicKey: publicKey, api: api)
    }

    public func getBalance() throws -> Decimal {
        return try cellService.getUnspentCells().reduce(0, { $0 + Decimal(string: $1.capacity)! })
    }

    public func sendCapacity(targetLock: Script, capacity: Decimal) throws -> H256 {
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
        return Transaction(deps: deps, inputs: validInputs.cellInputs, outputs: outputs, hash: privateKey)
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


