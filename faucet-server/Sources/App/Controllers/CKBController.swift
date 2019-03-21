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
    }

    func faucet(_ req: Request) -> Response {
        let accessToken = req.http.cookies.all[AccessTokenCookieName]?.string
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
        return Response(http: HTTPResponse(body: HTTPBody(string: result.toJson)), using: req.sharedContainer)
    }
}
