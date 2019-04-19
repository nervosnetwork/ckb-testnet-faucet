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
        let verifyStatus = Authorization().verify(accessToken: accessToken)
        let result: [String: Any]

        if verifyStatus == .tokenIsVailable {
            let urlParameters = req.http.urlString.urlParametersDecode
            do {
                if let address = urlParameters["address"] {
                    let txhash = try CKBService.shared.faucet(address: address)
                    Authorization().recordCollectionDate(accessToken: accessToken!)
                    result = ["status": 0, "txhash": txhash]
                } else {
                     result = ["status": -3, "error": "No address"]
                }
            } catch {
                result = ["status": -4, "error": error.localizedDescription]
            }
        } else {
            result = ["status": verifyStatus.rawValue, "error": "Verify failed"]
        }

        return Response(http: HTTPResponse(body: HTTPBody(string: result.toJson)), using: req.sharedContainer)
    }

    func address(_ req: Request) -> Response {
        let urlParameters = req.http.urlString.urlParametersDecode
        let result: [String: Any]
        do {
            if let privateKey = urlParameters["privateKey"] {
                let address = try CKBService.privateToAddress(privateKey)
                result = ["address": address, "status": 0]
            } else if let publicKey = urlParameters["publicKey"] {
                let address = try CKBService.publicToAddress(publicKey)
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
        let privateKey = CKBService.generatePrivateKey()
        let result: [String: Any] = [
            "privateKey": privateKey,
            "publicKey": try! CKBService.privateToPublic(privateKey),
            "address": try! CKBService.privateToAddress(privateKey)
        ]
        let headers = HTTPHeaders([("Access-Control-Allow-Origin", "*")])
        return Response(http: HTTPResponse(headers: headers, body: HTTPBody(string: result.toJson)), using: req.sharedContainer)
    }
}
