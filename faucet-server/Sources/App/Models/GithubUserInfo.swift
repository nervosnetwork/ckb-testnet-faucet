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
    public init(email: String?, loginDate: String?) {
        self.email = email
        self.loginDate = loginDate
    }

    public init() {
        
    }
}

extension GithubUserInfo {
    public mutating func save() {
        loginDate = getDateNow()
        do {
            print(FileManager.default.currentDirectoryPath)
            try connection.run(githubTable.insert(
                emailExpression <- email,
                loginDateExpression <- loginDate
            ))
        } catch {}
    }

    public static func getAll() -> [GithubUserInfo] {
        var all: [GithubUserInfo] = []
        for githubUserInfo in try! connection.prepare(githubTable) {
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

private let connection = try! Connection(.uri(FileManager.default.currentDirectoryPath + "/githubUserInfo.db"))
private let githubTable = createTable()
private let emailExpression = Expression<String?>("email")
private let loginDateExpression = Expression<String?>("loginDate")

private func createTable() -> Table {
    let table = Table("githubUserInfo")
    try? connection.run(table.create { t in
        t.column(emailExpression)
        t.column(loginDateExpression)
    })
    return table
}
