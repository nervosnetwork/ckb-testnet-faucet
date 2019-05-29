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
    case invalidPrivateKey = -4
    case invalidPublicKey = -5
    case sendTransactionFailed = -6
    case publickeyOrPrivatekeyNotExist = -7
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
        case .invalidPrivateKey:
            return "Invalid private key"
        case .invalidPublicKey:
            return "Invalid public key"
        case .sendTransactionFailed:
            return "Send transaction failed"
        case .publickeyOrPrivatekeyNotExist:
            return "Publickey or privatekey not exist"
        }
    }
}
