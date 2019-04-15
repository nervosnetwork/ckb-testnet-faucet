//
//  Bech32Tests.swift
//  AppTests
//
//  Created by 翟泉 on 2019/4/15.
//

import App
import XCTest
import Vapor

class Bech32Tests: XCTestCase {
    func testEncodeAndDecode() throws {
        let text = "azusa"
        let data = text.data(using: .utf8)!
        if let data = convertbits(data: data, frombits: 8, tobits: 5, pad: true) {
            let res = Bech32.encode(hrp: "ckt", data: data)
            XCTAssertEqual("ckt1v9a82ump732can", res)
            if let decodeResult = Bech32.decode(res) {
                if let textData =  convertbits(data: decodeResult.1, frombits: 5, tobits: 8, pad: false) {
                    XCTAssertEqual(String(data: textData, encoding: .utf8), text)
                } else {
                    XCTAssert(false)
                }
            } else {
                XCTAssert(false)
            }
        } else {
            XCTAssert(false)
        }
    }
}
