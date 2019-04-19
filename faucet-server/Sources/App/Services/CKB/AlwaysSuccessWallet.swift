//
//  AlwaysSuccessAccount.swift
//  App
//
//  Created by 翟泉 on 2019/3/29.
//

import Foundation
import CKB

class AlwaysSuccessWallet: Wallet {
    override var lock: Script {
        return Script.alwaysSuccess
    }

    init(api: APIClient) throws {
        try super.init(api: api, privateKey: "")
    }

    override func gatherInputs(capacity: Capacity, minCapacity: Capacity = minCellCapacity) throws -> ValidInputs {
        let validInputs = try super.gatherInputs(capacity: capacity, minCapacity: minCapacity)
        let cellInputs = validInputs.cellInputs.map { CellInput(previousOutput: $0.previousOutput, args: []) }
        return ValidInputs(cellInputs: cellInputs, capacity: validInputs.capacity)
    }
}
