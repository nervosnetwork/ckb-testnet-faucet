//
//  AuthorizationService.swift
//  App
//
//  Created by 翟泉 on 2019/3/12.
//

import Foundation
import Vapor

class Authentication {
    func verify(userId: Int?, on connection: Request) -> EventLoopFuture<ResponseStatus> {
        guard let userId = userId else {
            return connection.sharedContainer.eventLoop.newSucceededFuture(result: .unauthenticated)
        }
        return User
            .query(on: connection)
            .filter(\.userId, .equal, userId)
            .first()
            .map { user -> ResponseStatus in
            if let user = user {
                if user.recentlyReceivedDate?.timeIntervalSince1970 ?? 0 < Date().timeIntervalSince1970 - 24 * 60 * 60 {
                    return .ok
                } else {
                    return .received
                }
            } else {
                return .unauthenticated
            }
        }
    }

    func authorization(for accessToken: String, user: GithubService.User, on connection: Request) throws -> EventLoopFuture<Response> {
        return User
            .query(on: connection)
            .filter(\.userId, .equal, user.id)
            .first()
            .flatMap { userExist -> EventLoopFuture<Response> in
                var user = userExist ?? User(userId: user.id, name: user.login, email: user.email)
                user.authorizationDate = Date()
                return user.save(on: connection).encode(status: .ok, for: connection)
            }.flatMap { _ in
                return Auth(accessToken: accessToken, userId: user.id).save(on: connection).encode(status: .ok, for: connection)
            }
    }

    func recordReceivedDate(for userId: Int, on connection: Request) -> EventLoopFuture<Response> {
        return User
            .query(on: connection)
            .filter(\.userId, .equal, userId)
            .first()
            .flatMap { userExist -> EventLoopFuture<Response> in
                var user = userExist ?? User(userId: userId)
                user.recentlyReceivedDate = Date()
                return user.save(on: connection).encode(status: .ok, for: connection)
            }
    }
}
