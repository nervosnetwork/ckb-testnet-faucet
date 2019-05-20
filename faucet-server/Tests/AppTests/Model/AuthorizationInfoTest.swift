//
//  GithubUserInfoTest.swift
//  AppTests
//
//  Created by XiaoLu on 2019/5/17.
//

import XCTest
import App

class AuthorizationInfoTest: XCTestCase {
    func testExample() throws {
        try AuthorizationInfo(email: "xxx@cryptape.com").save()
        XCTAssertTrue(try AuthorizationInfo.getAll().contains(where: {$0.email == "xxx@cryptape.com"}))
    }
}
