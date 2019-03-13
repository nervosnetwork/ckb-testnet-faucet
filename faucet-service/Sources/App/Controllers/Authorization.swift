//
//  Authorization.swift
//  App
//
//  Created by 翟泉 on 2019/3/12.
//

import Foundation
import Vapor

struct Authorization: RouteCollection {
    func boot(router: Router) throws {
        router.get("auth/verify", use: verify)
        try router.register(collection: Github())
    }

    func verify(_ req: Request) -> Response {
        let accessToken = req.http.cookies.all[AccessTokenCookieName]?.string

        let status = VerifyAccessToken.shared.verify(accessToken: accessToken)

        let result = ["status": status.rawValue]
        let body: HTTPBody
        if let callback = req.http.url.absoluteString.urlParametersDecode["callback"] {
            body = HTTPBody(string: "\(callback)(\(result.toJson))")
        } else {
            body = HTTPBody(string: result.toJson)
        }
        return Response(http: HTTPResponse(body: body), using: req.sharedContainer)
    }
}

extension Authorization {
    struct Github {
    }
}

extension Authorization.Github: RouteCollection {
    func boot(router: Router) throws {
        router.get("auth/github/callback", use: callback)
    }

    func callback(_ req: Request) -> Response {
        let parameters = req.http.url.absoluteString.urlParametersDecode
        guard let code = parameters["code"], let state = parameters["state"] else {
            return Response(http: HTTPResponse(status: HTTPResponseStatus(statusCode: 404)), using: req)
        }

        // Exchange this code for an access token
        let accessToken = requestAccessToken(code: code)

        // Redirect back to Web page
        let headers = HTTPHeaders([("Location", state)])
        var http = HTTPResponse(status: HTTPResponseStatus(statusCode: 302), headers: headers)

        // If the validation is successful, Add access token Cookie
        if let accessToken = accessToken {
            let domain = URL(string: state)?.host
            http.cookies = HTTPCookies(
                dictionaryLiteral: (AccessTokenCookieName, HTTPCookieValue(string: accessToken, domain: domain))
            )
        }

        return Response(http: http, using: req.sharedContainer)
    }
}
