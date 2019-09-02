//
//  CKBControllerTests.swift
//  AppTests
//
//  Created by 翟泉 on 2019/3/25.
//

import App
import XCTest
import Vapor
import CKB

class CKBControllerTests: XCTestCase {
    override func invokeTest() {
        if ProcessInfo.processInfo.environment["SKIP_CKB_API_TESTS"] == "1" {
            return
        }
        super.invokeTest()
    }

    override func setUp() {
        super.setUp()
        DispatchQueue.global().async {
            do {
                try App(.detect(arguments: [
                    "",
                    "--env", "dev",
                    "--port", "22333",
                    "--node_url", "http://localhost:8114",
                    "--wallet_private_key", ""  // Set a valid wallet private key
                ])).run()
            } catch {
                XCTAssert(false, error.localizedDescription)
            }
        }
        Thread.sleep(forTimeInterval: 2)
    }
}
