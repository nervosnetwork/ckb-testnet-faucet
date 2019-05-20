//
//  AuthorizationService.swift
//  App
//
//  Created by 翟泉 on 2019/3/12.
//

import Foundation

class Authorization {
    enum Status: Int {
        case tokenIsVailable = 0
        case unauthenticated = -1
        case received = -2
    }

    func verify(accessToken: String?) -> Status {
        if let accessToken = accessToken {
            if let user = User.query(accessToken: accessToken) {
                if user.recentlyReceivedDate?.timeIntervalSince1970 ?? 0 < Date().timeIntervalSince1970 - 24 * 60 * 60 {
                    return .tokenIsVailable
                } else {
                    return .received
                }
            } else {
                return .unauthenticated
            }
        } else {
            return .unauthenticated
        }
    }

    func authorization(code: String) -> String? {
        // Exchange this code for an access token
        guard let accessToken = GithubService.getAccessToken(code: code) else { return nil }
        var user: User
        if let result = User.query(accessToken: accessToken) {
            user = result
            user.authorizationDate = Date()
        } else {
            user = User(accessToken: accessToken)
        }
        try? user.save()
        try? AuthorizationInfo(accrssToken: accessToken).save()

        return accessToken
    }

    func recordCollectionDate(accessToken: String) {
        if var user = User.query(accessToken: accessToken) {
            user.recentlyReceivedDate = Date()
            try? user.save()
        }
    }

}
