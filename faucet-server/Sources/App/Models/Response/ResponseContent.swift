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

extension ResponseContent: ResponseEncodable {
}

// MARK: - Extensions

extension Future where T: Content {
    func makeJson(on request: Request) throws -> Future<Response> {
        return try map { ResponseContent(data: $0) }.encode(for: request)
    }
}

extension Future where T == ResponseStatus {
    func makeJson(on req: Request) -> Future<Response> {
        return flatMap({ (status) -> EventLoopFuture<Response> in
            return try ResponseContent<EmptyResponseContent>(status: status).encode(for: req)
        })
    }
}

extension Future where T == Response {
    func supportJsonp(on req: Request) -> Future<Response> {
        return map { res in
            guard let callback = req.http.url.absoluteString.urlParametersDecode["callback"] else { return res }
            if let data = res.http.body.data {
                if let text = String(data: data, encoding: .utf8), !text.hasPrefix("jsonp_") && text.hasPrefix("{") {
                    res.http.body = HTTPBody(string: callback + "(" + text + ")")
                }
            }
            return res
        }
    }
}

extension Content {
    func makeJson(for req: Request) throws -> Future<Response> {
        return try ResponseContent<Self>(data: self).encode(for: req)
    }
}
