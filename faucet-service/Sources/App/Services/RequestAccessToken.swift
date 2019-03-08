//
//  RequestAccessToken.swift
//  App
//
//  Created by 翟泉 on 2019/3/7.
//

import Foundation

let globalURLSession = URLSession(configuration: URLSessionConfiguration.default)

// Sync
func requestAccessToken(code: String) -> String? {
    var accessToken: String?
    var request = URLRequest(url: URL(string: "https://github.com/login/oauth/access_token")!)
    request.httpMethod = "POST"
    request.httpBody = [
        "client_id": GithubOAuthClientId,
        "client_secret": GithubOAuthClientSecret,
        "code": code
    ].urlParametersEncode.data(using: .utf8)

    let group = DispatchGroup()
    group.enter()
    globalURLSession.dataTask(with: request) { (data, response, error) in
        defer { group.leave() }
        guard let data = data else { return }
        accessToken = String(data: data, encoding: .utf8)?.urlParametersDecode["access_token"]
        }.resume()
    group.wait()
    return accessToken
}
