//
//  AuthorizationService.swift
//  App
//
//  Created by 翟泉 on 2019/3/7.
//

import Foundation
import SQLite

class VerifyAccessToken {
    enum Status: Int {
        case tokenIsVailable = 0
        case unauthenticated = -1
        case received = -2
    }

    static let shared = VerifyAccessToken()

    func verify(accessToken: String?) -> Status {
        if let accessToken = accessToken {
            if isAvailableAccessToken(accessToken) {
                return .tokenIsVailable
            } else {
                return .received
            }
        } else {
            return .unauthenticated
        }
    }

    private func isAvailableAccessToken(_ accessToken: String) -> Bool {
        guard let time = (try? getReceiveTokenTime(accessToken: accessToken)) as? TimeInterval else {
            return true
        }
        return time < Date().timeIntervalSince1970 - 24 * 60 * 60
    }

    private func recordReceiveTokenTime(accessToken: String, time: TimeInterval = Date().timeIntervalSince1970) throws {
        let result = accessTokenTable.filter(accessTokenColumn == accessToken)
        if try db.scalar(result.count) > 0 {
            try db.run(result.update(accessTokenColumn <- accessToken, timeColumn <- time))
        } else {
            try db.run(accessTokenTable.insert(accessTokenColumn <- accessToken, timeColumn <- time))
        }
    }

    private func getReceiveTokenTime(accessToken: String) throws -> TimeInterval? {
        let res = accessTokenTable.filter(accessTokenColumn == accessToken)
        for item in try db.prepare(res) {
            return item[timeColumn]
        }
        return nil
    }

    private let db: Connection
    private let accessTokenTable: Table
    private let accessTokenColumn: Expression<String>
    private let timeColumn: Expression<TimeInterval>

    private init() {
        db = try! Connection(.inMemory)

        accessTokenTable = Table("access_tokens")
        accessTokenColumn = Expression<String>("accessToken")
        timeColumn = Expression<TimeInterval>("time")

        _ = try? db.run(accessTokenTable.create { t in
            t.column(accessTokenColumn, primaryKey: true)
            t.column(timeColumn)
        })
    }
}
