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
        if ProcessInfo.processInfo.environment["SKIP_CKB_API_TESTS"] == "1" {
            return
        }
        super.invokeTest()
    }

    func testBalance() throws {
        let nodeUrl = URL(string: "")! // Set a valid ckb node url
        let api = APIClient(url: nodeUrl)
        let systemScript = try SystemScript.loadSystemScript(nodeUrl: nodeUrl)

        let wallet = Wallet(api: api, systemScript: systemScript, privateKey: "") // Set a valid wallet private key
        XCTAssert(try wallet.getBalance() > 0)
    }

    func testSendCapacity() throws {
        let nodeUrl = URL(string: "")! // Set a valid ckb node url
        let api = APIClient(url: nodeUrl)
        let systemScript = try SystemScript.loadSystemScript(nodeUrl: nodeUrl)

        let wallet = Wallet(api: api, systemScript: systemScript, privateKey: "") // Set a valid wallet private key

        let newWallet = Wallet(api: api, systemScript: systemScript, privateKey: CKBController.generatePrivateKey())
        let txhash = try wallet.sendCapacity(targetLock: newWallet.lock, capacity: 20000000000)

        var repeatCount = 20
        while repeatCount > 0 {
            Thread.sleep(forTimeInterval: 6)
            do {
                _ = try api.getTransaction(hash: txhash)
                XCTAssert(try newWallet.getBalance() >= 20000000000)
                break
            } catch {
                repeatCount -= 1
                if repeatCount == 0 {
                    XCTAssert(false, "Transaction failed")
                }
            }
        }
    }
}
