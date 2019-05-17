//
//  GithubUserInfoTest.swift
//  AppTests
//
//  Created by XiaoLu on 2019/5/17.
//

import XCTest
import App

class GithubUserInfoTest: XCTestCase {
    func testExample() {
        let githubUserInfo = GithubUserInfo(email: "xxx@cryptape.com")
        githubUserInfo.save()
        let githubUserInfoArray = GithubUserInfo.getAll()
        let isExist = githubUserInfoArray.contains(where: {$0.email == "xxx@cryptape.com"})
        XCTAssertTrue(isExist)
    }
}
