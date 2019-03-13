//
//  CKB.swift
//  App
//
//  Created by 翟泉 on 2019/3/12.
//

import Foundation
import Vapor

struct CKB: RouteCollection {
    func boot(router: Router) throws {
        router.get("ckb/getToken", use: getTestToken)
    }

    func getTestToken(_ req: Request) -> Response {
        let accessToken = req.http.cookies.all[AccessTokenCookieName]?.string
        let status = VerifyAccessToken.shared.verify(accessToken: accessToken)
        var result: [String: Any] = ["status": status.rawValue]

        if status == .tokenIsVailable {
            // TODO: Send transaction
            result["txhash"] = "xxxxxxxxx"
        }

        return Response(http: HTTPResponse(body: HTTPBody(string: result.toJson)), using: req.sharedContainer)
    }
}
