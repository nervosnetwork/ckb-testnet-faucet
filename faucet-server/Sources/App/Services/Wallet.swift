//
//  Account.swift
//  App
//
//  Created by 翟泉 on 2019/3/29.
//

import Foundation
import Vapor
import CKB

public class Wallet {
    let api: APIClient
    let privateKey: String
    let systemScript: SystemScript

    private var cellService: CellService!

    var publicKey: H256 {
        return "0x" + Utils.privateToPublic(privateKey)
    }

    public var lock: Script {
        let publicKeyHash = "0x" + AddressGenerator(network: .testnet).hash(for: Data(hex: publicKey)).toHexString()
        return Script(args: [publicKeyHash], codeHash: systemScript.secp256k1TypeHash, hashType: .type)
    }

    public init() throws {
        let nodeUrl = URL(string: Environment.CKB.nodeURL)!
        api = APIClient(url: nodeUrl)
        systemScript = try SystemScript.loadSystemScript(nodeUrl: nodeUrl)
        privateKey = Environment.CKB.walletPrivateKey
        cellService = CellService(lockHash: lock.hash, publicKey: publicKey, api: api)
    }

    public func getBalance() throws -> Decimal {
        return try cellService.getUnspentCells().reduce(0, { $0 + Decimal(string: $1.0.capacity)! })
    }

    public func sendTestTokens(to: String) throws -> H256 {
        let capacity = Environment.CKB.sendCapacityCount!
        let minCellCapacity = Decimal(60 * pow(10, 8))
        guard capacity >= minCellCapacity else {
            throw Error.tooLowCapacity(min: minCellCapacity.description)
        }

        guard let publicKeyHash = AddressGenerator(network: .testnet).publicKeyHash(for: to) else {
             throw Error.invalidAddress
        }
        let targetLock = Script(args: [Utils.prefixHex(publicKeyHash)], codeHash: systemScript.secp256k1TypeHash, hashType: .type)


        let tx = try generateTransaction(targetLock: targetLock, capacity: capacity)
        return try api.sendTransaction(transaction: tx)
    }

    // MARK: Utils

    func generateTransaction(targetLock: Script, capacity: Decimal) throws -> Transaction {
        let deps = [CellDep(outPoint: systemScript.depOutPoint, depType: .depGroup)]
        let validInputs = try cellService.gatherInputs(capacity: capacity)
        var witnesses = [Witness()]
        var outputs: [CellOutput] = [CellOutput(capacity: "\(capacity)", lock: targetLock, type: nil)]
        if validInputs.capacity > capacity {
            outputs.append(CellOutput(capacity: "\(validInputs.capacity - capacity)", lock: lock, type: nil))
            witnesses.append(Witness())
        }
        let tx = Transaction(cellDeps: deps, inputs: validInputs.cellInputs, outputs: outputs, witnesses: witnesses)
        let txhash = try api.computeTransactionHash(transaction: tx)
        return try Transaction.sign(tx: tx, with: Data(hex: privateKey), txHash: txhash)
    }
}

extension Wallet {
    enum Error: LocalizedError {
        case tooLowCapacity(min: Capacity)
        case invalidAddress

        var localizedDescription: String {
            switch self {
            case .tooLowCapacity(let min):
                return "Capacity cannot less than \(min)"
            case .invalidAddress:
                return "Invalid address"
            }
        }
    }
}
