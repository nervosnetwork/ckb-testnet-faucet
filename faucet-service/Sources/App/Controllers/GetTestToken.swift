//
//  GetTestToken.swift
//  App
//
//  Created by 翟泉 on 2019/3/7.
//

import Foundation
import Vapor
import SQLite

func getTestToken(_ req: Request) throws -> Response {
    let accessToken = req.http.cookies.all[AccessTokenCookieName]?.string
    let status = VerifyAccessToken.shared.verify(accessToken: accessToken)
    var result: [String: Any] = ["status": status.rawValue]

    if status == .tokenIsVailable {
        // TODO: Send transaction
        result["txhash"] = "xxxxxxxxx"
    }

    return Response(http: HTTPResponse(body: HTTPBody(string: result.toJson)), using: req.sharedContainer)
}
