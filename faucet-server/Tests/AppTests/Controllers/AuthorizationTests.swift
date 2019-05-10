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
                try App(.detect(arguments: ["",
                                            "--env", "dev",
                                            "--port", "22333",
                    ])).run()
            } catch {
                XCTAssert(false, error.localizedDescription)
            }
        }
        Thread.sleep(forTimeInterval: 2)
    }

    func testVerify() throws {
        // Setup access token
        let accessToken = "nanannananana"
        let user = User(accessToken: accessToken, authorizationDate: Date(), collectionDate: nil)
        try user.save()

        // Init request
        let cookie = HTTPCookie(properties: [.name: "github_access_token", .value: accessToken, .domain: "*", .path: "*"])!
        let header = HTTPCookie.requestHeaderFields(with: [cookie])
        var request = URLRequest(url: URL(string: "http://localhost:22333/auth/verify")!)
        request.setValue(header["Cookie"], forHTTPHeaderField: "Cookie")

        let result = try sendSyncRequest(request: request)
        let json = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as! [String: Any]
        XCTAssertEqual(json["status"] as? Int, 0)
    }
}
