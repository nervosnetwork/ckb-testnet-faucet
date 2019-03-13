//
//  GithubAPI.swift
//  App
//
//  Created by 翟泉 on 2019/3/13.
//

import Foundation

struct GithubAPI {
    static func getAccessToken(code: String) -> String? {
        var request = URLRequest(url: URL(string: "https://github.com/login/oauth/access_token")!)
        request.httpMethod = "POST"
        request.httpBody = [
            "client_id": GithubOAuthClientId,
            "client_secret": GithubOAuthClientSecret,
            "code": code
        ].urlParametersEncode.data(using: .utf8)

        do {
            let data = try sendSyncRequest(request: request)
            return String(data: data, encoding: .utf8)?.urlParametersDecode["access_token"]
        } catch {
            return nil
        }
    }
}
