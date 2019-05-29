//
//  AddressRequestContent.swift
//  App
//
//  Created by 翟泉 on 2019/5/29.
//

import Foundation
import Vapor

struct AddressRequestContent: Content {
    let privateKey: String?
    let publicKey: String?
}

extension AddressRequestContent: RequestDecodable {
    static func decode(from req: Request) throws -> Future<AddressRequestContent> {
        let urlParameters = req.http.urlString.urlParametersDecode
        return Future.map(on: req) {
            return AddressRequestContent(privateKey: urlParameters["privateKey"], publicKey: urlParameters["publicKey"])
        }
    }
}
