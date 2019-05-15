//
//  GithubAPI.swift
//  App
//
//  Created by 翟泉 on 2019/3/13.
//

import Foundation
import Vapor

struct GithubAPI {
    static func getAccessToken(code: String) -> String? {
        var request = URLRequest(url: URL(string: "https://github.com/login/oauth/access_token")!)
        request.httpMethod = "POST"
        request.httpBody = [
            "client_id": Environment.Process.oauthClientId!,
            "client_secret": Environment.Process.oauthClientSecret!,
            "code": code
        ].urlParametersEncode.data(using: .utf8)

        do {
            let data = try request.load()
            return String(data: data, encoding: .utf8)?.urlParametersDecode["access_token"]
        } catch {
            return nil
        }
    }

    static func getUserEmail(accessToken: String) -> String? {
        let request = URLRequest(url: URL(string: "https://api.github.com/user?access_token=\(accessToken)")!)

        guard let data = try? request.load() else { return nil }
        let githubUserInfo = try? JSONDecoder().decode(GithubUserInfo.self, from: data)
        return githubUserInfo?.email
    }
}
