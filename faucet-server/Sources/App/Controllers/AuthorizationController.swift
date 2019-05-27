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
        router.group("auth") { router in
            router.get("verify", use: verify)
            router.group("github", configure: { router in
                router.get("callback", use: callback)
            })
        }
    }

    func verify(_ req: Request) throws -> Future<Response> {
        let accessToken = req.http.cookies.all[accessTokenCookieName]?.string ?? ""
        let user = try? GithubService.getUserInfo(for: accessToken)
        return Authentication().verify(userId: user?.id, on: req).map { status -> String in
            // Support jsonp
            let result = ["status": status.rawValue]
            if let callback = req.http.url.absoluteString.urlParametersDecode["callback"] {
                return "\(callback)(\(result.toJson))"
            } else {
                return result.toJson
            }
        }.encode(status: .ok, for: req)
    }

    func callback(_ req: Request) throws -> Future<Response> {
        let parameters = req.http.url.absoluteString.urlParametersDecode
        guard let code = parameters["code"], let state = parameters["state"] else {
            throw Abort(HTTPStatus.badRequest)
        }

        // Exchange this code for an access token
        guard let accessToken = GithubService.getAccessToken(for: code) else {
            throw Abort(HTTPStatus.badRequest)
        }
        guard let user = try? GithubService.getUserInfo(for: accessToken) else {
            throw Abort(HTTPStatus.badRequest)
        }

        return  try Authentication().authorization(for: accessToken, user: user, on: req).flatMap { _ in
            // Redirect
            var http = HTTPResponse(status: .found, headers: HTTPHeaders([("Location", state)]))
            http.cookies = HTTPCookies(
                dictionaryLiteral: (accessTokenCookieName, HTTPCookieValue(string: accessToken, domain: URL(string: state)?.host))
            )
            return req.sharedContainer.eventLoop.newSucceededFuture(result: Response(http: http, using: req.sharedContainer))
        }
    }
}
