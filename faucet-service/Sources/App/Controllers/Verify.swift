//
//  Login.swift
//  App
//
//  Created by 翟泉 on 2019/3/7.
//

import Foundation
import Vapor
import SQLite

func verify(_ req: Request) -> Response {
    let accessToken = req.http.cookies.all[AccessTokenCookieName]?.string
    let status = VerifyAccessToken.shared.verify(accessToken: accessToken)

    let result = ["status": status.rawValue]
    let callback = req.http.url.absoluteString.urlParameters["callback"] ?? "callback"
    let body = HTTPBody(string: "\(callback)(\(result.toJson))")

    return Response(http: HTTPResponse(body: body), using: req.sharedContainer)
}
