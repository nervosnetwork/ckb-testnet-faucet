//
//  Email.swift
//  App
//
//  Created by XiaoLu on 2019/5/15.
//

import Foundation
import SQLite

public struct GithubUserInfo: Codable {
    public var email: String?
    public var loginDate: String?
    public init() {}

    public init(email: String?, loginDate: String?) {
        self.email = email
        self.loginDate = loginDate
    }
}

extension GithubUserInfo {
    private static let connection = try! Connection(.uri(FileManager.default.currentDirectoryPath + "/githubUserInfo.db"))
    private static let table = createTable()
    private static let emailExpression = Expression<String?>("email")
    private static let loginDateExpression = Expression<String?>("loginDate")

    private static func createTable() -> Table {
        let table = Table("githubUserInfo")
        try? connection.run(table.create { t in
            t.column(emailExpression)
            t.column(loginDateExpression)
        })
        return table
    }

    public mutating func save() {
        loginDate = getDateNow()
        do {
            print(FileManager.default.currentDirectoryPath)
            try GithubUserInfo.connection.run(GithubUserInfo.table.insert(
                GithubUserInfo.emailExpression <- email,
                GithubUserInfo.loginDateExpression <- loginDate
            ))
        } catch {}
    }

    public static func getAll() -> [GithubUserInfo] {
        var all: [GithubUserInfo] = []
        for githubUserInfo in try! connection.prepare(GithubUserInfo.table) {
            var githubUser = GithubUserInfo()
            githubUser.email = githubUserInfo[emailExpression]
            githubUser.loginDate = githubUserInfo[loginDateExpression]
            all.append(githubUser)
        }
        return all
    }

    private func getDateNow() -> String {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd 'at' HH:mm:ss.SSS"
        let nowTime = timeFormatter.string(from: date)
        return nowTime
    }
}


