//
//  CKBServiceTests.swift
//  AppTests
//
//  Created by 翟泉 on 2019/4/30.
//

import App
import XCTest
import Vapor

class CKBServiceTests: XCTestCase {
    func testGeneratePrivateKey() {
        let privateKey = CKBService.generatePrivateKey()
        XCTAssertEqual(privateKey.lengthOfBytes(using: .utf8), 64)
        // There is no `#undef` in swift
        // Not tested results in other systems
    }
}
