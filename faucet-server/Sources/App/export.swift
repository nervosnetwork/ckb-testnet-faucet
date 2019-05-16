//
//  export.swift
//  App
//
//  Created by XiaoLu on 2019/5/16.
//

import Foundation
import Vapor

public class Export {
    var env: Environment

    public init(_ env: Environment) throws {
        self.env = env
        try Environment.Process.configure(&self.env)
    }

    public func run() {
        File.SaveCSV(filePath: Environment.Process.saveFilePath!)
    }
}
