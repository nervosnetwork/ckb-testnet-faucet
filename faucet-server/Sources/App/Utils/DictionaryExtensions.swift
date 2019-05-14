//
//  DictionaryExtensions.swift
//  App
//
//  Created by 翟泉 on 2019/3/7.
//

import Foundation

extension Dictionary {
    var toJson: String {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) else { return "" }
        let jsonText = String(data: jsonData, encoding: .utf8)!
        return jsonText.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
    }

    public var urlParametersEncode: String {
        var string = ""
        for (_, element) in self.enumerated() {
            string += "\(element.key)=\(element.value)&"
        }
        string.removeLast()
        return string
    }
}
