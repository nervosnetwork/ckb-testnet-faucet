//
//  CKBService.swift
//  App
//
//  Created by 翟泉 on 2019/3/12.
//

import Foundation
import CKB

class CKB {
    func faucet(address: String) -> String? {
        return nil
    }

    static func privateToAddress(_ privateKey: String) throws -> String {
        if privateKey.hasPrefix("0x") && privateKey.lengthOfBytes(using: .utf8) == 66 {
            return Utils.privateToAddress(String(privateKey.dropFirst(2)))
        } else if privateKey.lengthOfBytes(using: .utf8) == 64 {
            return Utils.privateToAddress(privateKey)
        } else {
            throw Error.invalidPrivateKey
        }
    }

    static func publicToAddress(_ publicKey: String) throws -> String {
        if publicKey.hasPrefix("0x") && publicKey.lengthOfBytes(using: .utf8) == 68 {
            return Utils.publicToAddress(String(publicKey.dropFirst(2)))
        } else if publicKey.lengthOfBytes(using: .utf8) == 66 {
            return Utils.publicToAddress(publicKey)
        } else {
            throw Error.invalidPrivateKey
        }
    }

    static func privateToPublic(_ privateKey: String) throws -> String {
        if privateKey.hasPrefix("0x") && privateKey.lengthOfBytes(using: .utf8) == 66 {
            return Utils.privateToPublic(String(privateKey.dropFirst(2)))
        } else if privateKey.lengthOfBytes(using: .utf8) == 64 {
            return Utils.privateToPublic(privateKey)
        } else {
            throw Error.invalidPrivateKey
        }
    }

    static func generatePrivateKey() -> String {
        var data = Data(repeating: 0, count: 32)
        data.withUnsafeMutableBytes({ _ = SecRandomCopyBytes(kSecRandomDefault, 32, $0.baseAddress! ) })
        return data.toHexString()
    }
}

extension CKB {
    enum Error: String, Swift.Error {
        case invalidPrivateKey = "Invalid privateKey"
        case invalidPublicKey = "Invalid publicKey"
    }
}
