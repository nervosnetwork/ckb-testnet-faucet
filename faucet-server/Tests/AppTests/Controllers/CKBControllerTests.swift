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

    func testFaucet() throws {
        // Setup access token
        let accessToken = "nanannananana"
        let user = User(accessToken: accessToken, authorizationDate: Date(), collectionDate: nil)
        try user.save()

        let privateKey = "b7a5e163e4963751ed023acfc2b93deb03169b71a4abe3d44abf4123ff2ce2a3"
        let address = try CKBService.privateToAddress(privateKey)

        // Send faucet request
        let cookie = HTTPCookie(properties: [.name: "github_access_token", .value: accessToken, .domain: "*", .path: "*"])!
        let header = HTTPCookie.requestHeaderFields(with: [cookie])
        var request = URLRequest(url: URL(string: "http://localhost:22333/ckb/faucet?address=\(address)")!)
        request.setValue(header["Cookie"], forHTTPHeaderField: "Cookie")
        request.httpMethod = "POST"

        let result = try sendSyncRequest(request: request)
        let json = try JSONSerialization.jsonObject(with: result, options: .allowFragments) as! [String: Any]

        // Search tx
        if let txhash = json["txhash"] as? String {
            var repeatCount = 20
            let client = APIClient()
            while repeatCount > 0 {
                Thread.sleep(forTimeInterval: 6)
                do {
                    _ = try client.getTransaction(hash: txhash)
                    break
                } catch {
                    repeatCount -= 1
                    if repeatCount == 0 {
                        XCTAssert(false, "Transaction failed")
                    }
                }
            }
        } else {
            XCTAssert(false, "Send transaction failed")
        }
    }
}
