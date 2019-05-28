//
//  AuthenticationRequestModel.swift
//  App
//
//  Created by 翟泉 on 2019/5/28.
//

import Foundation
import Vapor

struct AuthenticationRequestModel: Content {
    let code: String
    let state: String
}

extension AuthenticationRequestModel: RequestDecodable {
    static func decode(from req: Request) throws -> Future<AuthenticationRequestModel> {
        let parameters = req.http.url.absoluteString.urlParametersDecode
        guard let code = parameters["code"], let state = parameters["state"] else {
            throw Abort(HTTPStatus.badRequest)
        }
        return Future.map(on: req) {  AuthenticationRequestModel(code: code, state: state) }
    }
}
