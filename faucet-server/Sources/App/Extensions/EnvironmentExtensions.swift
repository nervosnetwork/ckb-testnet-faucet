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

        static func configure(_ environment: inout Environment) {
            nodeURL = try? environment.commandInput.parse(option: .value(name: "node_url")) ?? ""
            oauthClientId = try? environment.commandInput.parse(option: .value(name: "github_oauth_client_id")) ?? ""
            oauthClientSecret = try? environment.commandInput.parse(option: .value(name: "github_oauth_client_secret")) ?? ""
        }
    }
}
