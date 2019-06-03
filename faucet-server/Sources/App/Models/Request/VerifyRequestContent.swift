//
//  VerifyRequestModel.swift
//  App
//
//  Created by 翟泉 on 2019/5/28.
//

import Foundation
import Vapor

struct VerifyRequestContent: Content {
    let accessToken: String?
}

extension VerifyRequestContent: RequestDecodable {
    static func decode(from req: Request) throws -> Future<VerifyRequestContent> {
        let accessToken = req.http.cookies.all[accessTokenCookieName]?.string ?? ""
        return Future.map(on: req) {  VerifyRequestContent(accessToken: accessToken) }
    }
}
