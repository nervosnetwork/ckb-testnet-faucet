//
//  CKB.swift
//  App
//
//  Created by 翟泉 on 2019/3/12.
//

import Foundation
import Vapor

struct CKBController: RouteCollection {
    func boot(router: Router) throws {
        router.post("ckb/faucet", use: faucet)
        router.get("ckb/address", use: address)
        router.get("ckb/address/random", use: makeRandomAddress)
    }

    func faucet(_ req: Request) -> Response {
        let accessToken = req.http.cookies.all[accessTokenCookieName]?.string
        let status = Authorization().verify(accessToken: accessToken)
        var result: [String: Any] = ["status": status.rawValue]

        if status == .tokenIsVailable {
            // TODO: Send transaction
            result["txhash"] = "xxxxxxxxx"
        }

        return Response(http: HTTPResponse(body: HTTPBody(string: result.toJson)), using: req.sharedContainer)
    }

    func address(_ req: Request) -> Response {
        let urlParameters = req.http.urlString.urlParametersDecode
        let result: [String: Any]
        do {
            if let privateKey = urlParameters["privateKey"] {
                let address = try CKB.privateToAddress(privateKey)
                result = ["address": address, "status": 0]
            } else if let publicKey = urlParameters["publicKey"] {
                let address = try CKB.publicToAddress(publicKey)
                result = ["address": address, "status": 0]
            } else {
                result = ["status": -1, "error": "No public or private key"]
            }
        } catch {
            result = ["status": -2, "error": error.localizedDescription]
        }
        let headers = HTTPHeaders([("Access-Control-Allow-Origin", "*")])
        return Response(http: HTTPResponse(headers: headers, body: HTTPBody(string: result.toJson)), using: req.sharedContainer)
    }

    func makeRandomAddress(_ req: Request) -> Response {
        let privateKey = CKB.generatePrivateKey()
        let result: [String: Any] = [
            "privateKey": privateKey,
            "publicKey": try! CKB.privateToPublic(privateKey),
            "address": try! CKB.privateToAddress(privateKey)
        ]
        let headers = HTTPHeaders([("Access-Control-Allow-Origin", "*")])
        return Response(http: HTTPResponse(headers: headers, body: HTTPBody(string: result.toJson)), using: req.sharedContainer)
    }
}
