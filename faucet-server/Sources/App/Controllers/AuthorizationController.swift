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
                router.get("callback", use: authentication)
            })
        }
    }

    func verify(_ req: Request) throws -> Future<Response> {
        return try VerifyRequestContent.decode(from: req).flatMap { (content: VerifyRequestContent) -> EventLoopFuture<Response> in
            return GithubService.userInfo(for: content.accessToken ?? "", on: req).flatMap { (user) -> EventLoopFuture<Response> in
                return AuthenticationService().verify(userId: user?.id, on: req).makeJson(on: req)
            }
        }.supportJsonp(on: req)
    }

    func authentication(_ req: Request) throws -> Future<Response> {
        return try AuthenticationRequestContent.decode(from: req).flatMap{ (content) -> EventLoopFuture<Response> in
            return GithubService.accessToken(for: content.code, on: req).unwrap(or: Abort(HTTPStatus.badRequest)).flatMap { (accessToken) -> EventLoopFuture<Response> in
                return GithubService.userInfo(for: accessToken, on: req).unwrap(or: Abort(HTTPStatus.badRequest)).flatMap { (user) -> EventLoopFuture<Response> in
                    return try AuthenticationService().authorization(for: accessToken, user: user, on: req).flatMap { _ in
                        var http = HTTPResponse(status: .found, headers: HTTPHeaders([("Location", content.state)]))
                        http.cookies = HTTPCookies(
                            dictionaryLiteral: (accessTokenCookieName, HTTPCookieValue(string: accessToken, domain: URL(string: content.state)?.host))
                        )
                        return req.sharedContainer.eventLoop.newSucceededFuture(result: Response(http: http, using: req.sharedContainer))
                    }
                }
            }
        }
    }
}
