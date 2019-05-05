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
    public func save() {
        do {
            let filterResult = userTable.filter(accessTokenExpression == accessToken)
            do {
                try connection.run(userTable.insert(
                    accessTokenExpression <- accessToken,
                    authorizationDateExpression <- authorizationDate,
                    collectionDateExpression <- collectionDate
                ))
            } catch {
                try connection.run(filterResult.update(
                    accessTokenExpression <- accessToken,
                    authorizationDateExpression <- authorizationDate,
                    collectionDateExpression <- collectionDate
                ))
            }
        } catch {
        }
    }

    public static func query(accessToken: String) -> User? {
        let filterResult = userTable.filter(accessTokenExpression == accessToken)
        do {
            guard let userRow = try connection.prepare(filterResult).first(where: { _ in true }) else { return nil }
            let accessToken = userRow[accessTokenExpression]
            let authorizationDate = userRow[authorizationDateExpression]
            let collectionDate = userRow[collectionDateExpression]
            return User(accessToken: accessToken, authorizationDate: authorizationDate, collectionDate: collectionDate)
        } catch {
            return nil
        }
    }
}

extension User: Equatable {
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.accessToken == rhs.accessToken
    }
}

// MARK: - Private

private let connection = try! Connection(.inMemory)
private let userTable = createTable()
private let accessTokenExpression = Expression<String>("accessToken")
private let authorizationDateExpression = Expression<Date>("authorizationDate")
private let collectionDateExpression = Expression<Date?>("collectionDate")

private func createTable() -> Table {
    let table = Table("User")
    try! connection.run(table.create { t in
        t.column(accessTokenExpression, primaryKey: true)
        t.column(authorizationDateExpression)
        t.column(collectionDateExpression)
    })
    return table
}
