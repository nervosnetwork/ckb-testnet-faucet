//
//  Authorization.swift
//  App
//
//  Created by 翟泉 on 2019/3/12.
//

import Foundation
import Vapor

struct AuthorizationController: RouteCollection {
    func boot(router: Router) throws {
        router.group("auth") { (router) in
            router.get("verify", use: verify)
            router.group("github", configure: { (router) in
                router.get("callback", use: callback)
            })
        }
    }

    func verify(_ req: Request) throws -> Future<Response> {
        let accessToken = req.http.cookies.all[accessTokenCookieName]?.string ?? ""

        return Authorization().verify(accessToken: accessToken, on: req).map({ (status) -> String in
            let result = ["status": status.rawValue]
            if let callback = req.http.url.absoluteString.urlParametersDecode["callback"] {
                return "\(callback)(\(result.toJson))"
            } else {
                return result.toJson
            }
        }).encode(status: .ok, for: req)
    }

    func callback(_ req: Request) throws -> Future<Response> {
        let parameters = req.http.url.absoluteString.urlParametersDecode
        guard let code = parameters["code"], let state = parameters["state"] else {
            throw Abort(HTTPStatus.badRequest)
        }

        /// Exchange this code for an access token
        guard let accessToken = GithubService.getAccessToken(for: code) else {
            throw Abort(HTTPStatus.badRequest)
        }

        return  try Authorization().authorization(for: accessToken, on: req).map { res in
            var http = HTTPResponse(status: .found, headers: HTTPHeaders([("Location", state)]))
            http.cookies = HTTPCookies(
                dictionaryLiteral: (accessTokenCookieName, HTTPCookieValue(string: accessToken, domain: URL(string: state)?.host))
            )
            res.http = http
            return res
        }
    }
}
