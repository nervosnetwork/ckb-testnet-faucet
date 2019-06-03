//
//  ResponseModel.swift
//  App
//
//  Created by 翟泉 on 2019/5/28.
//

import Foundation
import Vapor

struct ResponseContent<T: Content>: Content {
    var status: ResponseStatus
    var message: String
    var data: T?
}

extension ResponseContent {
    init(data: T? = nil) {
        status = .ok
        message = status.description
        self.data = data
    }

    init(status: ResponseStatus, message: String? = nil) {
        self.status = status
        self.message = message != nil ? message! : self.status.description
    }
}
