//
//  StringExtensions.swift
//  App
//
//  Created by 翟泉 on 2019/3/7.
//

import Foundation

extension String {
    public var urlParametersDecode: [String: String] {
        guard let string = self.components(separatedBy: "?").last else { return [:] }
        var parameters = [String: String]()
        string.components(separatedBy: "&").forEach { (keyValue) in
            let components = keyValue.components(separatedBy: "=")
            guard components.count == 2 else { return }
            parameters[components[0]] = components[1].removingPercentEncoding
        }
        return parameters
    }
}
