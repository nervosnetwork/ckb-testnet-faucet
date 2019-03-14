//
//  SendSyncRequest.swift
//  App
//
//  Created by 翟泉 on 2019/3/12.
//

import Foundation

public func sendSyncRequest(request: URLRequest) throws -> Data {
    var data: Data?
    var error: Error?

    let group = DispatchGroup()
    group.enter()
    let session = URLSession(configuration: URLSessionConfiguration.default)
    session.dataTask(with: request) { (responseData, _, responseError) in
        data = responseData
        error = responseError
        group.leave()
    }.resume()
    group.wait()

    if data != nil {
        return data!
    } else {
        throw error!
    }
}

