//
//  Email.swift
//  App
//
//  Created by XiaoLu on 2019/5/15.
//

import Foundation
import SQLite

public struct AuthorizationInfo: Codable {
    public let email: String
    public let authorizationDate: String

    public init(email: String, authorizationDate: String = AuthorizationInfo.getDateNow()) {
        self.email = email
        self.authorizationDate = authorizationDate
    }

    public init(accrssToken: String) throws {
        email = try GithubService.getUserInfo(for: accrssToken).email
        authorizationDate = AuthorizationInfo.getDateNow()
    }
}

extension AuthorizationInfo {
    private static let connection = try! Connection(.uri(FileManager.default.currentDirectoryPath + "/authorization_log.db"))
    private static let table = createTable()
    private static let emailColumn = Expression<String>("email")
    private static let loginDateColumn = Expression<String>("authorization_date")

    private static func createTable() -> Table {
        let table = Table("github_user_info")
        _ = try? connection.run(table.create { t in
            t.column(emailColumn)
            t.column(loginDateColumn)
        })
        return table
    }

    public func save() throws {
        try AuthorizationInfo.connection.run(AuthorizationInfo.table.insert(
            AuthorizationInfo.emailColumn <- email,
            AuthorizationInfo.loginDateColumn <- authorizationDate
        ))
    }

    public static func getAll() throws -> [AuthorizationInfo] {
        return try connection.prepare(AuthorizationInfo.table).map {
            AuthorizationInfo(email: $0[emailColumn], authorizationDate: $0[loginDateColumn])
        }
    }

    public static func getDateNow() -> String {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd 'at' HH:mm:ss.SSS"
        let nowTime = timeFormatter.string(from: date)
        return nowTime
    }
}

