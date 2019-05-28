//
//  Auth.swift
//  App
//
//  Created by 翟泉 on 2019/5/22.
//

import Foundation
import Vapor
import Fluent
import FluentMySQL

struct Auth: Content, MySQLModel, Migration {
    var id: Int?

    var userId: Int
    var accessToken: String
    var date: Date

    init(accessToken: String, userId: Int) {
        self.accessToken = accessToken
        self.userId = userId
        date = Date()
    }
}
