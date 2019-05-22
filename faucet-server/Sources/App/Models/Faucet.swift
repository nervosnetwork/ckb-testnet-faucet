//
//  Faucet.swift
//  App
//
//  Created by 翟泉 on 2019/5/22.
//

import Foundation
import Vapor
import Fluent
import FluentMySQL

struct Faucet: Content, MySQLModel {
    var id: Int?

    var email: String
    var txHash: String
    var date: Date
    
    init(email: String, txHash: String) {
        self.email = email
        self.txHash = txHash
        self.date = Date()
    }
}

extension Faucet: Migration {
    public static func prepare(on connection: MySQLConnection) -> Future<Void> {
        return Database.create(Faucet.self, on: connection) {
            builder in
            try addProperties(to: builder)
        }
    }

    public static func revert(on connection: MySQLConnection) -> Future<Void> {
        return Database.delete(Faucet.self, on: connection)
    }
}
