//
//  UserModel.swift
//  App
//
//  Created by 翟泉 on 2019/3/12.
//

import Foundation
import SQLite

public struct User {
    public let accessToken: String
    public var authorizationDate: Date
    public var collectionDate: Date?

    public init(accessToken: String, authorizationDate: Date, collectionDate: Date?) {
        self.accessToken = accessToken
        self.authorizationDate = authorizationDate
        self.collectionDate = collectionDate
    }
}

extension User {
    private static let connection = try! Connection(.uri(FileManager.default.currentDirectoryPath + "/user.db"))
    private static let table = createTable()
    private static let accessTokenColumn = Expression<String>("access_token")
    private static let authorizationDateColumn = Expression<Date>("authorization_date")
    private static let collectionDateColumn = Expression<Date?>("collection_date")

    private static func createTable() -> Table {
        let table = Table("user")
        try! connection.run(table.create { t in
            t.column(accessTokenColumn, primaryKey: true)
            t.column(authorizationDateColumn)
            t.column(collectionDateColumn)
        })
        return table
    }

    public func save() throws {
        do {
            try User.connection.run(User.table.insert(
                User.accessTokenColumn <- accessToken,
                User.authorizationDateColumn <- authorizationDate,
                User.collectionDateColumn <- collectionDate
            ))
        } catch {
            let filterResult = User.table.filter(User.accessTokenColumn == accessToken)
            try User.connection.run(filterResult.update(
                User.accessTokenColumn <- accessToken,
                User.authorizationDateColumn <- authorizationDate,
                User.collectionDateColumn <- collectionDate
            ))
        }
    }

    public static func query(accessToken: String) -> User? {
        let query = table.filter(accessTokenColumn == accessToken)
        guard let row = try? connection.prepare(query).first(where: { _ in true }) else { return nil }
        return User(
            accessToken: row[accessTokenColumn],
            authorizationDate: row[authorizationDateColumn],
            collectionDate: row[collectionDateColumn]
        )
    }
}

extension User: Equatable {
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.accessToken == rhs.accessToken
    }
}
