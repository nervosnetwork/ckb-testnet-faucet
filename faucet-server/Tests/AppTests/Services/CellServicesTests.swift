//
//  CellServicesTests.swift
//  App
//
//  Created by 翟泉 on 2019/5/22.
//

import Foundation
import XCTest
import Vapor
import App

class CellServicesTests: XCTestCase {

    func testSaveAndRead() {
        CellService.saveBlockNumber(2333, for: "azusa")
        CellService.saveBlockNumber(123, for: "mio")
        CellService.saveBlockNumber(435, for: "yui")

        XCTAssertEqual(2333, CellService.readBlockNumber(for: "azusa"))
        XCTAssertEqual(123, CellService.readBlockNumber(for: "mio"))
        XCTAssertEqual(435, CellService.readBlockNumber(for: "yui"))
    }
    
}
