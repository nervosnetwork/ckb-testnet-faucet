//
//  CKBControllerTests.swift
//  AppTests
//
//  Created by 翟泉 on 2019/3/25.
//

import App
import XCTest
import Vapor

class CKBControllerTests: XCTestCase {
    override func invokeTest() {
        if ProcessInfo().environment["SKIP_CKB_API_TESTS"] == "1" {
            return
        }
        super.invokeTest()
    }

    override func setUp() {
        super.setUp()
        DispatchQueue.global().async {
            do {
                try app(.detect(arguments: ["",
                                            "--env", "dev",
                                            "--port", "22333",
                                            "--node_url", "http://localhost:8114",
                                            "--github_oauth_client_id", "",
                                            "--github_oauth_client_secret", ""
                    ])).run()
            } catch {
                XCTAssert(false, error.localizedDescription)
            }
        }
        Thread.sleep(forTimeInterval: 2)
    }

    func testGenerateAddress() throws {
        let request = URLRequest(url: URL(string: "http://localhost:22333/ckb/address/random")!)
        let result = try sendSyncRequest(request: request)
        do {
            let dict = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as! [String: Any]
            XCTAssert(dict["address"] != nil && dict["privateKey"] != nil && dict["publicKey"] != nil)
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }
}
