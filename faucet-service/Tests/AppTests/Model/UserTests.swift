//
//  UserTests.swift
//  AppTests
//
//  Created by 翟泉 on 2019/3/13.
//

import App
import XCTest

class UserTests: XCTestCase {
    func testUser() {
        let accessToken = "nananana"
        var user = User(accessToken: accessToken, authorizationDate: Date(), collectionDate: nil)
        user.save()
        XCTAssertEqual(user, User.query(accessToken: accessToken))

        user.collectionDate = Date()
        user.save()
        XCTAssert(User.query(accessToken: accessToken)?.collectionDate != nil)
    }
}
