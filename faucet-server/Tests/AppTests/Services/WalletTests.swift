//
//  WalletTests.swift
//  AppTests
//
//  Created by 翟泉 on 2019/5/5.
//

import XCTest
import CKB
@testable import App

class WalletTests: XCTestCase {
    let wallet = try! Wallet(nodeUrl: URL(string: "http://127.0.0.1:8114")!, privateKey: "0x")

    func x_testSendTestTokens() {
        do {
            let toAddress = "ckt1qyqy0frc0r8kus23ermqkxny662m37yc26fqpcyqky"
            let txhash = try wallet.sendTestTokens(to: toAddress, amount: Capacity(100 * 100_000_000))
            XCTAssertFalse(txhash.isEmpty)
        } catch {
            XCTFail()
        }
    }
}
