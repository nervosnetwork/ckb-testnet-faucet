//
//  Convertbits.swift
//  Bech32
//
//  Created by 翟泉 on 2019/4/15.
//  Copyright © 2019 cezres. All rights reserved.
//

import Foundation

public func convertbits(data: Data, frombits: Int, tobits: Int, pad: Bool) -> Data? {
    var ret = Data()
    var acc = 0
    var bits = 0
    let maxv = (1 << tobits) - 1
    for p in 0..<data.count {
        let value = data[p]
        if value < 0 || (value >> frombits) != 0 {
            return nil
        }
        acc = (acc << frombits) | Int(value)
        bits += frombits
        while bits >= tobits {
            bits -= tobits
            ret.append(UInt8((acc >> bits) & maxv))
        }
    }
    if pad {
        if bits > 0 {
            ret.append(UInt8((acc << (tobits - bits)) & maxv))
        }
    } else if bits >= frombits || ((acc << (tobits - bits)) & maxv) > 0 {
        return nil
    }
    return ret
}
