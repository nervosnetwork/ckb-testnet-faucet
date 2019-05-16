//
//  EnvironmentExtensions.swift
//  App
//
//  Created by 翟泉 on 2019/4/28.
//

import Vapor

extension Environment {
    struct Process {
        static var nodeURL: String!
        static var oauthClientId: String!
        static var oauthClientSecret: String!
        static var walletPrivateKey: String!
        static var sendCapacityCount: Decimal!
        static var saveFilePath: String?

        static func configure(_ environment: inout Environment) throws {
            saveFilePath = try? environment.commandInput.parse(option: .value(name: "save_file_path"))
            walletPrivateKey = try? environment.commandInput.parse(option: .value(name: "wallet_private_key"))
            nodeURL = try environment.commandInput.parse(option: .value(name: "node_url"))
            sendCapacityCount = Decimal(string: (try? environment.commandInput.parse(option: .value(name: "send_capacity_count"))) ?? "20000000000")!
            oauthClientId = try environment.commandInput.parse(option: .value(name: "github_oauth_client_id"))
            oauthClientSecret = try environment.commandInput.parse(option: .value(name: "github_oauth_client_secret"))
        }
    }
}
