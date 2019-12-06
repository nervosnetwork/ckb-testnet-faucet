//
//  GithubService.swift
//  App
//
//  Created by 翟泉 on 2019/3/13.
//

import Foundation
import Vapor
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

struct GithubService {
    struct User: Decodable {
        let email: String?
        let id: Int
        let login: String
    }

    static func userInfo(for accessToken: String, on req: Request) -> EventLoopFuture<User?> {
        return Future.map(on: req) {
            do {
                let request = URLRequest(url: URL(string: "https://api.github.com/user?access_token=\(accessToken)")!)
                let responseData = try request.load()
                return try JSONDecoder().decode(User.self, from: responseData)
            } catch {
                return nil
            }
        }
    }

    static func accessToken(for code: String, on req: Request) -> EventLoopFuture<String?> {
        return Future.map(on: req) {
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
    }
}
