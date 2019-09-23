//
//  Account.swift
//  App
//
//  Created by 翟泉 on 2019/3/29.
//

import Foundation
import CKB

final class Wallet {
    let api: APIClient
    let privateKey: String

    private var address: String {
        return Utils.privateToAddress(privateKey, network: .testnet)
    }

    init(nodeUrl: URL, privateKey: String) throws {
        self.privateKey = privateKey
        api = APIClient(url: nodeUrl)
    }

    func sendTestTokens(to: String, amount: Capacity) throws -> H256 {
        let payment = try Payment(
            from: address,
            to: to,
            amount: amount,
            apiClient: api
        )
        try payment.sign(privateKey: Data(hex: privateKey))
        let hash = try payment.send()
        CellService.saveBlockNumber(payment.lastBlockNumber, for: address)
        return hash
    }
}
