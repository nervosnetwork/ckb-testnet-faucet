//
//  Auth.swift
//  App
//
//  Created by 翟泉 on 2019/5/22.
//

import Foundation
import Vapor
import Fluent
import FluentMySQL

struct Auth: Content, MySQLModel {
    var id: Int?

    var userId: Int
    var accessToken: String
    var date: Date

    init(accessToken: String, userId: Int) {
        self.accessToken = accessToken
        self.userId = userId
        date = Date()
    }
}

extension Auth: Migration {
    public static func prepare(on connection: MySQLConnection) -> Future<Void> {
        return Database.create(Auth.self, on: connection) {
            builder in
            try addProperties(to: builder)
        }
    }

    public static func revert(on connection: MySQLConnection) -> Future<Void> {
        return Database.delete(Auth.self, on: connection)
    }
}
