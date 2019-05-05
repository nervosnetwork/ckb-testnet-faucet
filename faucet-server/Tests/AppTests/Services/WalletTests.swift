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
    override func invokeTest() {
        if ProcessInfo().environment["SKIP_CKB_API_TESTS"] == "1" {
            return
        }
        super.invokeTest()
    }

    func testBalance() throws {
        let client = APIClient()
        let asw = try AlwaysSuccessWallet(api: client)
        XCTAssert(try asw.getBalance() > 0)
    }

    func testSendCapacity() throws {
        let client = APIClient()
        let asw = try AlwaysSuccessWallet(api: client)
        let privateKey = CKBService.generatePrivateKey()

        let wallet = try Wallet(api: client, privateKey: privateKey)
        let txhash = try asw.sendCapacity(targetLock: wallet.lock, capacity: 10000)

        var repeatCount = 20
        while repeatCount > 0 {
            Thread.sleep(forTimeInterval: 6)
            do {
                _ = try client.getTransaction(hash: txhash)
                XCTAssert(try wallet.getBalance() >= 10000)
                break
            } catch {
                repeatCount -= 1
                if repeatCount == 0 {
                    XCTAssert(false, "transaction failed")
                }
            }
        }
    }
}
