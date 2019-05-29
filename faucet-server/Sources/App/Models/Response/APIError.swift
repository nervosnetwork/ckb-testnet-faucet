//
//  APIError.swift
//  App
//
//  Created by 翟泉 on 2019/5/28.
//

import Foundation
import Vapor

struct APIError {
    var identifier: String
    var reason: String
    var code: ResponseStatus

    init(code: ResponseStatus, message: String? = nil) {
        self.identifier = "api error: \(code.rawValue)"
        self.reason = message ?? code.description
        self.code = code
    }
}

extension APIError: AbortError {
    var status: HTTPResponseStatus {
        return .ok
    }
}
