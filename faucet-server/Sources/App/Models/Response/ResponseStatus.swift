//
//  ResponseStatus.swift
//  App
//
//  Created by 翟泉 on 2019/5/28.
//

import Foundation
import Vapor

enum ResponseStatus: Int, Content {
    case ok = 0
    case unauthenticated = -1
    case received = -2
    case invalidAddress = -3
    case sendTransactionFailed = -6
}

extension ResponseStatus: CustomStringConvertible {
    var description: String {
        switch self {
        case .ok:
            return "Request successful"
        case .unauthenticated:
            return "Unauthenticated"
        case .received:
            return "Received"
        case .invalidAddress:
            return "Invalid address"
        case .sendTransactionFailed:
            return "Send transaction failed"
        }
    }
}
