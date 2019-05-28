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
        return try VerifyRequestModel.decode(from: req).flatMap { (container: VerifyRequestModel) -> EventLoopFuture<Response> in
            let user = try? GithubService.getUserInfo(for: container.accessToken ?? "")
            return Authentication().verify(userId: user?.id, on: req).makeJson(on: req)
        }.supportJsonp(on: req)
    }

    func authentication(_ req: Request) throws -> Future<Response> {
        return try AuthenticationRequestModel.decode(from: req).flatMap{ (model) -> EventLoopFuture<Response> in
            guard let accessToken = GithubService.getAccessToken(for: model.code) else {
                throw Abort(HTTPStatus.badRequest)
            }
            guard let user = try? GithubService.getUserInfo(for: accessToken) else {
                throw Abort(HTTPStatus.badRequest)
            }
            return try Authentication().authorization(for: accessToken, user: user, on: req).flatMap { _ in
                var http = HTTPResponse(status: .found, headers: HTTPHeaders([("Location", model.state)]))
                http.cookies = HTTPCookies(
                    dictionaryLiteral: (accessTokenCookieName, HTTPCookieValue(string: accessToken, domain: URL(string: model.state)?.host))
                )
                return req.sharedContainer.eventLoop.newSucceededFuture(result: Response(http: http, using: req.sharedContainer))
            }
        }
    }
}
