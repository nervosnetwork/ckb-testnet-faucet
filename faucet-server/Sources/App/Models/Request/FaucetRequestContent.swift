//
//  FaucetRequestModel.swift
//  App
//
//  Created by 翟泉 on 2019/5/28.
//

import Foundation
import Vapor

struct FaucetRequestContent: Content {
    let address: String
    let accessToken: String?
}

extension FaucetRequestContent: RequestDecodable {
    static func decode(from req: Request) throws -> Future<FaucetRequestContent> {
        let accessToken = req.http.cookies.all[accessTokenCookieName]?.string ?? ""
        let urlParameters = req.http.urlString.urlParametersDecode
        guard let address = urlParameters["address"] else { throw Abort(HTTPStatus.badRequest) }
        return Future.map(on: req) {
            return FaucetRequestContent(address: address, accessToken: accessToken)
        }
    }
}
