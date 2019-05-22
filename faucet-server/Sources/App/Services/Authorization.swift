//
//  AuthorizationService.swift
//  App
//
//  Created by 翟泉 on 2019/3/12.
//

import Foundation
import Vapor

class Authorization {
    enum Status: Int {
        case tokenIsVailable = 0
        case unauthenticated = -1
        case received = -2
    }

    func verify(accessToken: String, on connection: Request) -> EventLoopFuture<Status> {
        return User
            .query(on: connection)
            .filter(\.accessToken, .equal, accessToken)
            .first()
            .map({ (user) -> Authorization.Status in
            if let user = user {
                if user.recentlyReceivedDate?.timeIntervalSince1970 ?? 0 < Date().timeIntervalSince1970 - 24 * 60 * 60 {
                    return .tokenIsVailable
                } else {
                    return .received
                }
            } else {
                return .unauthenticated
            }
        })
    }

    func authorization(for accessToken: String, on connection: Request) throws -> EventLoopFuture<Response> {
        return User
            .query(on: connection)
            .filter(\.accessToken, .equal, accessToken)
            .first()
            .flatMap { (userExist) -> EventLoopFuture<Response> in
                var user = userExist ?? User(accessToken: accessToken)
                user.authorizationDate = Date()
                return user.save(on: connection).encode(status: .ok, for: connection)
            }.flatMap({ _ in
                try Auth(accessToken: accessToken).save(on: connection).encode(status: .ok, for: connection)
            })
    }

    func recordCollectionDate(for accessToken: String, on connection: Request) -> EventLoopFuture<Response> {
        return User
            .query(on: connection)
            .filter(\.accessToken, .equal, accessToken)
            .first()
            .flatMap { (userExist) -> EventLoopFuture<Response> in
                var user = userExist ?? User(accessToken: accessToken)
            user.recentlyReceivedDate = Date()
                return user.save(on: connection).encode(status: .ok, for: connection)
            }
    }
}
