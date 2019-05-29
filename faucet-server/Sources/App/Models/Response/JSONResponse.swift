//
//  ResponseSupportJsonp.swift
//  App
//
//  Created by 翟泉 on 2019/5/29.
//

import Foundation
import Vapor

// MARK: - Make JSON

extension Future where T: Content {
    func makeJson(on request: Request) throws -> Future<Response> {
        return try map { ResponseContent(data: $0) }.encode(for: request)
    }
}

extension Future where T == ResponseStatus {
    func makeJson(on req: Request) -> Future<Response> {
        return flatMap { (status) -> EventLoopFuture<Response> in
            return try ResponseContent<EmptyResponseContent>(status: status).encode(for: req)
        }
    }
}

extension Content {
    func makeJson(for req: Request) throws -> Future<Response> {
        return try ResponseContent<Self>(data: self).encode(for: req)
    }
}


// MARK: - Support JSONP

extension Future where T == Response {
    func supportJsonp(on req: Request) -> Future<Response> {
        return map { $0.supportJsonp(on: req) }
    }
}

extension Response {
    func supportJsonp(on req: Request) -> Response {
        guard let callback = req.http.url.absoluteString.urlParametersDecode["callback"] else { return self }
        if let data = http.body.data {
            if let text = String(data: data, encoding: .utf8), !text.hasPrefix("jsonp_") && text.hasPrefix("{") {
                http.body = HTTPBody(string: callback + "(" + text + ")")
            }
        }
        return self
    }
}
