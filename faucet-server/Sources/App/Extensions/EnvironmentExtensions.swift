//
//  EnvironmentExtensions.swift
//  App
//
//  Created by 翟泉 on 2019/4/28.
//

import Vapor

extension Environment {
    mutating func configure() throws {
        try CKB.configure(&self)
        try OAuth.configure(&self)
        try Database.configure(&self)
    }
}

extension Environment {
    struct CKB {
        private(set) static var nodeURL: String!
        private(set) static var walletPrivateKey: String!
        private(set) static var sendCapacityCount: Decimal!

        static func configure(_ environment: inout Environment) throws {
            walletPrivateKey = try environment.commandInput.parse(option: .value(name: "wallet_private_key"))
            nodeURL = try environment.commandInput.parse(option: .value(name: "node_url"))
            sendCapacityCount = Decimal(string: (try? environment.commandInput.parse(option: .value(name: "send_capacity_count"))) ?? "50000" + "00000000")!
        }
    }
}

extension Environment {
    struct OAuth {
        private(set) static var clientId: String!
        private(set) static var clientSecret: String!

        static func configure(_ environment: inout Environment) throws {
            clientId = try environment.commandInput.parse(option: .value(name: "github_oauth_client_id"))
            clientSecret = try environment.commandInput.parse(option: .value(name: "github_oauth_client_secret"))
        }
    }
}

extension Environment {
    struct Database {
        private(set) static var hostname: String!
        private(set) static var port: Int!
        private(set) static var username: String!
        private(set) static var password: String!
        private(set) static var database: String!

        static func configure(_ environment: inout Environment) throws {
            hostname = try environment.commandInput.parse(option: .value(name: "db_hostname"))
            port = Int(try environment.commandInput.parse(option: .value(name: "db_port"))!)!
            username = try environment.commandInput.parse(option: .value(name: "db_username"))
            password = try environment.commandInput.parse(option: .value(name: "db_password"))
            database = try? environment.commandInput.parse(option: .value(name: "db_database"))
        }
    }
}

