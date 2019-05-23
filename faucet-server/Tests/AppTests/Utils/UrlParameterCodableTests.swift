//
//  UrlParameterCodableTests.swift
//  AppTests
//
//  Created by 翟泉 on 2019/5/23.
//

import Foundation
import App
import XCTest

class UrlParameterCodeableTests: XCTestCase {
    func testUrlParameterEncode() {
        XCTAssertEqual(["aaa": "22", "xxxx": "zzz"], ["aaa": "22", "xxxx": "zzz"].urlParametersEncode.urlParametersDecode)
    }

    func testUrlParameterDecode() {
        XCTAssertEqual(["aaa": "22", "xxxx": "zzz"], "xxxx=zzz&aaa=22".urlParametersDecode)
    }
}
