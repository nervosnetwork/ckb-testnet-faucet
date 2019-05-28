//
//  VerifyRequestModel.swift
//  App
//
//  Created by 翟泉 on 2019/5/28.
//

import Foundation
import Vapor

struct VerifyRequestModel: Content {
    var accessToken: String?
}

extension VerifyRequestModel: RequestDecodable {
    static func decode(from req: Request) throws -> Future<VerifyRequestModel> {
        let accessToken = req.http.cookies.all[accessTokenCookieName]?.string ?? ""
        return Future.map(on: req) {  VerifyRequestModel(accessToken: accessToken) }
    }
}
