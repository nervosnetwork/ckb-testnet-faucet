//
//  Data+Extension.swift
//  Bech32
//
//  Created by 翟泉 on 2019/4/15.
//  Copyright © 2019 cezres. All rights reserved.
//

import Foundation

extension Data {
    public init(hex: String) {
        self.init(Array<UInt8>(hex: hex))
    }

    public var bytes: Array<UInt8> {
        return Array(self)
    }

    public func toHexString() -> String {
        return bytes.toHexString()
    }
}
