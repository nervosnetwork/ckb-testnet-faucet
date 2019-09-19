//
//  Account.swift
//  App
//
//  Created by 翟泉 on 2019/3/29.
//

import Foundation
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
        let publicKeyHash = AddressGenerator.hash(for: Data(hex: publicKey)).toHexString()
        return systemScript.lock(for: Utils.prefixHex(publicKeyHash))
    }

    public init(nodeUrl: URL, privateKey: String) throws {
        self.privateKey = privateKey
        api = APIClient(url: nodeUrl)
        systemScript = try SystemScript.loadSystemScript(nodeUrl: nodeUrl)
        cellService = CellService(lock: lock, api: api)
    }

    public func sendTestTokens(to: String, amount: Capacity) throws -> H256 {
        let minCellCapacity = Capacity(61 * 100_000_000)
        guard amount >= minCellCapacity else {
            throw Error.tooLowCapacity(min: minCellCapacity)
        }

        guard let publicKeyHash = AddressGenerator.publicKeyHash(for: to) else {
             throw Error.invalidAddress
        }
        let toLockScript = systemScript.lock(for: Utils.prefixHex(publicKeyHash))
        let tx = try generateTransaction(toLockScript: toLockScript, capacity: amount)
        return try api.sendTransaction(transaction: tx)
    }

    public func getBalance() throws -> Capacity {
        return try cellService.getUnspentCells().reduce(0, { $0 + $1.0.capacity })
    }

    // MARK: Utils

    func generateTransaction(toLockScript: Script, capacity: Capacity) throws -> Transaction {
        let deps = [CellDep(outPoint: systemScript.depOutPoint, depType: .depGroup)]
        let validInputs = try cellService.gatherInputs(capacity: capacity)
        var outputs: [CellOutput] = [CellOutput(capacity: capacity, lock: toLockScript, type: nil)]
        var outputsData: [HexString] = ["0x"]
        var witnesses = [Witness()]

        if validInputs.capacity > capacity {
            outputs.append(CellOutput(capacity: validInputs.capacity - capacity, lock: lock, type: nil))
            outputsData.append("0x")
            witnesses.append(Witness())
        }
        let tx = Transaction(
            cellDeps: deps,
            inputs: validInputs.cellInputs,
            outputs: outputs,
            outputsData: outputsData,
            witnesses: witnesses
        )
        return try Transaction.sign(tx: tx, with: Data(hex: privateKey))
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
