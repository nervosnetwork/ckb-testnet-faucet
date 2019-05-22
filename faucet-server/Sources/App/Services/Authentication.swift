//
//  AuthorizationService.swift
//  App
//
//  Created by 翟泉 on 2019/3/12.
//

import Foundation
import Vapor

class Authentication {
    enum Status: Int {
        case tokenIsVailable = 0
        case unauthenticated = -1
        case received = -2
    }

    func verify(email: String, on connection: Request) -> EventLoopFuture<Status> {
        return User
            .query(on: connection)
            .filter(\.email, .equal, email)
            .first()
            .map({ (user) -> Authentication.Status in
            if let user = user {
//                if user.recentlyReceivedDate?.timeIntervalSince1970 ?? 0 < Date().timeIntervalSince1970 - 24 * 60 * 60 {
//                    return .tokenIsVailable
//                } else {
//                    return .received
//                }
                return .tokenIsVailable
            } else {
                return .unauthenticated
            }
        })
    }

    func authorization(for accessToken: String, email: String, on connection: Request) throws -> EventLoopFuture<Response> {
        return User
            .query(on: connection)
            .filter(\.email, .equal, email)
            .first()
            .flatMap { (userExist) -> EventLoopFuture<Response> in
                var user = userExist ?? User(email: email)
                user.authorizationDate = Date()
                return user.save(on: connection).encode(status: .ok, for: connection)
            }.flatMap({ _ in
                Auth(accessToken: accessToken, email: email).save(on: connection).encode(status: .ok, for: connection)
            })
    }

    func recordReceivedDate(for email: String, on connection: Request) -> EventLoopFuture<Response> {
        return User
            .query(on: connection)
            .filter(\.email, .equal, email)
            .first()
            .flatMap { (userExist) -> EventLoopFuture<Response> in
                var user = userExist ?? User(email: email)
                user.recentlyReceivedDate = Date()
                return user.save(on: connection).encode(status: .ok, for: connection)
            }
    }
}
