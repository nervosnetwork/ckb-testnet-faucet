//
//  GithubService.swift
//  App
//
//  Created by 翟泉 on 2019/3/13.
//

import Foundation
import Vapor

struct GithubService {
    struct User: Decodable {
        let email: String
    }

    static func getAccessToken(for code: String) -> String? {
        var request = URLRequest(url: URL(string: "https://github.com/login/oauth/access_token")!)
        request.httpMethod = "POST"
        request.httpBody = [
            "client_id": Environment.OAuth.clientId!,
            "client_secret": Environment.OAuth.clientSecret!,
            "code": code
        ].urlParametersEncode.data(using: .utf8)

        do {
            let data = try request.load()
            return String(data: data, encoding: .utf8)?.urlParametersDecode["access_token"]
        } catch {
            return nil
        }
    }

    static func getUserInfo(for accessToken: String) throws -> User {
        let request = URLRequest(url: URL(string: "https://api.github.com/user?access_token=\(accessToken)")!)
        let responseData = try request.load()
        return try JSONDecoder().decode(User.self, from: responseData)
    }
}
