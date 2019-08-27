//
//  CKB.swift
//  App
//
//  Created by 翟泉 on 2019/3/12.
//

import Foundation
import Vapor
import CKB

public class CKBController: RouteCollection {
    let nodeUrl: URL
    private let api: APIClient
    private let systemScript: SystemScript

    private var faucetSending = [String]()
    private let authService = AuthenticationService()

    public init(nodeUrl: URL) throws {
        self.nodeUrl = nodeUrl
        api = APIClient(url: nodeUrl)
        systemScript = try SystemScript.loadSystemScript(nodeUrl: nodeUrl)
    }

    public func boot(router: Router) throws {
        router.get("ckb/faucet", use: faucet)
        router.get("ckb/address", use: address)
        router.get("ckb/address/random", use: makeRandomAddress)
    }

    // MARK: - API

    func faucet(_ req: Request) throws -> Future<Response> {
        return try FaucetRequestContent.decode(from: req).flatMap { (content) -> EventLoopFuture<Response> in
            guard let accessToken = content.accessToken else { throw APIError(code: .unauthenticated) }
            guard self.faucetSending.firstIndex(of: accessToken) == nil else {
                throw Abort(HTTPStatus.badRequest)
            }
            self.faucetSending.append(accessToken)

            return GithubService.userInfo(for: accessToken, on: req).unwrap(or: APIError(code: .unauthenticated)).flatMap { (user) -> EventLoopFuture<Response> in
                return self.authService.verify(userId: user.id, on: req).map { status -> Void in
                    if status == .ok {
                        return
                    } else {
                        throw APIError(code: status)
                    }
                }.map { _ in
                    do {
                        return try self.sendCapacity(address: content.address)
                    } catch {
                        throw APIError(code: .sendTransactionFailed)
                    }
                }.map { (txHash: H256) -> H256 in
                    _ = Faucet(userId: user.id, txHash: txHash).save(on: req)
                    _ = self.authService.recordReceivedDate(for: user.id, on: req)
                    return txHash
                }.flatMap { txHash -> EventLoopFuture<Response> in
                    return try FaucetResponseContent(txHash: txHash).makeJson(for: req)
                }
            }.always {
                self.faucetSending.remove(at: accessToken)
            }
        }.supportJsonp(on: req)
    }

    func address(_ req: Request) throws -> Future<Response> {
        return try AddressRequestContent.decode(from: req).flatMap { (content) -> EventLoopFuture<Response> in
            if let privateKey = content.privateKey {
                do {
                    let address = try CKBController.privateToAddress(privateKey)
                    return try AddressResponseContent(address: address).makeJson(for: req)
                } catch {
                    throw APIError(code: .invalidPrivateKey)
                }
            } else if let publicKey = content.publicKey {
                do {
                    let address = try CKBController.publicToAddress(publicKey)
                    return try AddressResponseContent(address: address).makeJson(for: req)
                } catch {
                    throw APIError(code: .invalidPublicKey)
                }
            } else {
                throw APIError(code: .publickeyOrPrivatekeyNotExist)
            }
        }
    }

    func makeRandomAddress(_ req: Request) throws ->  Future<Response> {
        let privateKey = CKBController.generatePrivateKey()
        return try [
            "privateKey": privateKey,
            "publicKey": try! CKBController.privateToPublic(privateKey),
            "address": try! CKBController.privateToAddress(privateKey)
        ].makeJson(for: req)
    }

    // MARK: - Utils

    public func sendCapacity(address: String) throws -> H256 {
        guard let publicKeyHash = AddressGenerator(network: .testnet).publicKeyHash(for: address) else { throw Error.invalidAddress }
        let targetLock = Script(args: [Utils.prefixHex(publicKeyHash)], codeHash: systemScript.secp256k1TypeHash, hashType: .type)

        let wallet = Wallet(api: api, systemScript: systemScript, privateKey: Environment.CKB.walletPrivateKey)
        return try wallet.sendCapacity(targetLock: targetLock, capacity: Environment.CKB.sendCapacityCount)
    }

    public static func privateToAddress(_ privateKey: String) throws -> String {
        return try publicToAddress(try privateToPublic(privateKey))
    }

    public static func publicToAddress(_ publicKey: String) throws -> String {
        switch validatePublicKey(publicKey) {
        case .valid(let value):
            return AddressGenerator(network: .testnet).address(for: value)
        case .invalid(let error):
            throw error
        }
    }

    public static func privateToPublic(_ privateKey: String) throws -> String {
        switch validatePrivateKey(privateKey) {
        case .valid(let value):
            return Utils.privateToPublic(value)
        case .invalid(let error):
            throw error
        }
    }

    public static func generatePrivateKey() -> String {
        var data = Data(repeating: 0, count: 32)
        #if os(OSX)
            data.withUnsafeMutableBytes({ _ = SecRandomCopyBytes(kSecRandomDefault, 32, $0.baseAddress! ) })
        #else
            for idx in 0..<32 {
                data[idx] = UInt8.random(in: UInt8.min...UInt8.max)
            }
        #endif
        return data.toHexString()
    }

    public static func validatePrivateKey(_ privateKey: String) -> VerifyResult {
        if privateKey.hasPrefix("0x") {
            if privateKey.lengthOfBytes(using: .utf8) == 66 {
                return .valid(value: String(privateKey.dropFirst(2)))
            } else {
                return .invalid(error: .invalidPrivateKey)
            }
        } else if privateKey.lengthOfBytes(using: .utf8) == 64 {
            return .valid(value: privateKey)
        } else {
            return .invalid(error: .invalidPrivateKey)
        }
    }

    public static func validatePublicKey(_ publicKey: String) -> VerifyResult {
        if publicKey.hasPrefix("0x") {
            if publicKey.lengthOfBytes(using: .utf8) == 68 {
                return .valid(value: publicKey)
            } else {
                return .invalid(error: .invalidPublicKey)
            }
        } else if publicKey.lengthOfBytes(using: .utf8) == 66 {
            return .valid(value: publicKey)
        } else {
            return .invalid(error: .invalidPublicKey)
        }
    }
}

extension CKBController {
    public enum Error: String, Swift.Error {
        case invalidPrivateKey = "Invalid privateKey"
        case invalidPublicKey = "Invalid publicKey"
        case invalidAddress = "Invalid address"
    }

    public enum VerifyResult {
        case valid(value: String)
        case invalid(error: Error)
    }

    public enum Status: Int {
        case succeed = 0
        case failed = -1
        case verifyFailed = -2
    }
}
