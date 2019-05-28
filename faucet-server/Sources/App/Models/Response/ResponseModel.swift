//
//  ResponseModel.swift
//  App
//
//  Created by 翟泉 on 2019/5/28.
//

import Foundation
import Vapor

struct ResponseModel<T: Content>: Content {
    var status: ResponseStatus
    var message: String
    var data: T?
}

extension ResponseModel {
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

extension ResponseModel: ResponseEncodable {
    
}

extension Future where T == ResponseStatus {
    func makeJson(on req: Request) -> Future<Response> {
        return flatMap({ (status) -> EventLoopFuture<Response> in
            return try ResponseModel<Empty>(status: status).encode(for: req)
        })
    }

    func makeJsonp(on req: Request) -> Future<Response> {
        return flatMap({ (status) -> EventLoopFuture<Response> in
            return try ResponseModel<Empty>(status: status).encode(for: req)
        }).map({ (res) -> (Response) in
            if let callback = req.http.url.absoluteString.urlParametersDecode["callback"] {
                if let data = res.http.body.data {
                    if let text = String(data: data, encoding: .utf8) {
                        res.http.body = HTTPBody(string: callback + "(" + text + ")")
                    }
                }
            }
            return res
        })
    }
}

extension Future where T == Response {

}
