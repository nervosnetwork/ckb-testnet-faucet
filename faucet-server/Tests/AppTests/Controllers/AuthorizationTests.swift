//
//  AuthorizationTests.swift
//  AppTests
//
//  Created by 翟泉 on 2019/3/12.
//

import App
import XCTest
import Vapor

class AuthorizationTests: XCTestCase {
    override func setUp() {
        super.setUp()
        DispatchQueue.global().async {
            do {
                try app(.detect(arguments: ["", "--env", "test"])).run()
            } catch {
                XCTAssert(false, error.localizedDescription)
            }
        }
        Thread.sleep(forTimeInterval: 2)
    }

    func testVerify() throws {
        let request = URLRequest(url: URL(string: "http://localhost:8080/auth/verify")!)
        let result = try sendSyncRequest(request: request)
        XCTAssertEqual(String(data: result, encoding: .utf8), "{\"status\":-1}")
    }
}
