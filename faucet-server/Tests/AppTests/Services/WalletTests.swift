//
//  WalletTests.swift
//  AppTests
//
//  Created by 翟泉 on 2019/5/5.
//

import App
import XCTest
import Vapor
import CKB

class WalletTests: XCTestCase {
    let wallet = try! Wallet(nodeUrl: URL(string: "http://127.0.0.1:8114")!, privateKey: "")

    func testSendTestTokens() {
        do {
            let toAddress = "ckt1qyqy0frc0r8kus23ermqkxny662m37yc26fqpcyqky"
            let txhash = try wallet.sendTestTokens(to: toAddress)
            XCTAssertFalse(txhash.isEmpty)
        } catch {
            print(error)
        }
    }

    func testGetBalance() throws {
        let balance = try wallet.getBalance()
        XCTAssert(balance >= 0)
    }
}
