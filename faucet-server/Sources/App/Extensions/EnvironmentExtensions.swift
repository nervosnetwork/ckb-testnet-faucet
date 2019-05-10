//
//  EnvironmentExtensions.swift
//  App
//
//  Created by 翟泉 on 2019/4/28.
//

import Vapor

extension Environment {
    struct Process {
        static var nodeURL: String! = nil
        static var oauthClientId: String! = nil
        static var oauthClientSecret: String! = nil
        static var minerPrivateKey: String! = nil
        static var sendCapacityCount: Decimal!

        static func configure(_ environment: inout Environment) throws {
            minerPrivateKey = try? environment.commandInput.parse(option: .value(name: "miner_private_key")) ?? ""
            nodeURL = try? environment.commandInput.parse(option: .value(name: "node_url")) ?? "http://localhost:8114"
            sendCapacityCount = Decimal(string: try? environment.commandInput.parse(option: .value(name: "send_capacity_count")) ?? "20000000000")!
            oauthClientId = try environment.commandInput.parse(option: .value(name: "github_oauth_client_id"))
            oauthClientSecret = try environment.commandInput.parse(option: .value(name: "github_oauth_client_secret"))
        }
    }
}
