//
//  URLRequestExtensions.swift
//  App
//
//  Created by 翟泉 on 2019/3/12.
//

import Foundation
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public extension URLRequest {
    func load() throws -> Data {
        var data: Data?
        var error: Error?

        let group = DispatchGroup()
        group.enter()
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: self) { (responseData, _, responseError) in
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
}

