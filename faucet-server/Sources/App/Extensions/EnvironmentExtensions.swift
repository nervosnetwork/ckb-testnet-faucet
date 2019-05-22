//
//  EnvironmentExtensions.swift
//  App
//
//  Created by 翟泉 on 2019/4/28.
//

import Vapor

extension Environment {
    struct Process {
        // ckb
        static var nodeURL: String!
        static var walletPrivateKey: String!
        static var sendCapacityCount: Decimal!
        // oauth
        static var oauthClientId: String!
        static var oauthClientSecret: String!
        // db
        static var dbHostname: String!
        static var dbPort: Int!
        static var dbUsername: String!
        static var dbPassword: String!
        static var dbDatabase: String!

        static func configure(_ environment: inout Environment) throws {
            walletPrivateKey = try environment.commandInput.parse(option: .value(name: "wallet_private_key"))
            nodeURL = try environment.commandInput.parse(option: .value(name: "node_url"))
            sendCapacityCount = Decimal(string: (try? environment.commandInput.parse(option: .value(name: "send_capacity_count"))) ?? "20000000000")!

            oauthClientId = try environment.commandInput.parse(option: .value(name: "github_oauth_client_id"))
            oauthClientSecret = try environment.commandInput.parse(option: .value(name: "github_oauth_client_secret"))

            dbHostname = try environment.commandInput.parse(option: .value(name: "db_hostname"))
            dbPort = Int(try environment.commandInput.parse(option: .value(name: "db_port"))!)!
            dbUsername = try environment.commandInput.parse(option: .value(name: "db_username"))
            dbPassword = try environment.commandInput.parse(option: .value(name: "db_password"))
            dbDatabase = try environment.commandInput.parse(option: .value(name: "db_database"))
        }
    }
}
