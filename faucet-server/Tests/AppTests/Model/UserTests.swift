//
//  UserTests.swift
//  AppTests
//
//  Created by 翟泉 on 2019/3/13.
//

import App
import XCTest

class UserTests: XCTestCase {
    func testUser() throws {
        let accessToken = "nananana"
        var user = User(accessToken: accessToken, authorizationDate: Date(), collectionDate: nil)
        try user.save()
        XCTAssertEqual(user, User.query(accessToken: accessToken))

        user.collectionDate = Date()
        try user.save()
        XCTAssert(User.query(accessToken: accessToken)?.collectionDate != nil)
    }
}
