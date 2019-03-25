//
//  Consts.swift
//  App
//
//  Created by 翟泉 on 2019/3/7.
//

import Foundation

let accessTokenCookieName = "github_access_token"

struct GithubOAuth {
    static private(set) var clientId = ""
    static private(set) var clientSecret = ""
}

extension GithubOAuth {
    static func config(clientId: String, clientSecret: String) {
        GithubOAuth.clientId = clientId
        GithubOAuth.clientSecret = clientSecret
    }
}
