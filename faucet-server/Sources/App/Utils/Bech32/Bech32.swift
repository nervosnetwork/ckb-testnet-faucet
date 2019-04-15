//
//  Bech32.swift
//  Bech32
//
//  Created by 翟泉 on 2019/4/12.
//  Copyright © 2019 cezres. All rights reserved.
//

import Foundation


public struct Bech32 {
    private static let GENERATOR = [0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3]
    private static let CHARSET = "qpzry9x8gf2tvdw0s3jn54khce6mua7l"

    public static func encode(hrp: String, data: Data) -> String {
        let checksum = createChecksum(hrp: hrp.data(using: .utf8)!, data: data)
        var ret = hrp + "1"
        ret += String((data + checksum).map { CHARSET[CHARSET.index(CHARSET.startIndex, offsetBy: Int($0))] })
        return ret
    }

    public static func decode(_ string: String) -> (String, Data)? {
        var hasLower = false
        var hasUpper = false
        for char in string.utf8 {
            if char < 33 || char > 126 {
                return nil
            }
            if char >= 97 && char <= 122 {
                hasLower = true
            }
            if char >= 65 && char <= 90 {
                hasUpper = true
            }
        }
        if hasLower && hasUpper {
            return nil
        }

        let string = string.lowercased()
        guard let posIndex = string.lastIndex(of: "1") else { return nil }
        let pos = Int(string.distance(from: string.startIndex, to: posIndex))
        if pos < 1 || pos + 7 > string.lengthOfBytes(using: .utf8) || string.lengthOfBytes(using: .utf8) > 90 { return nil }
        let hrp = String(string.dropLast(string.count - pos))
        var data = Data()

        for char in string.dropFirst(pos + 1) {
            guard let d = CHARSET.lastIndex(of: char) else { return nil }
            let index = UInt8(CHARSET.distance(from: CHARSET.startIndex, to: d))
            data.append(index)
        }

        if !verifyChecksum(hrp: hrp, data: data) {
            return nil
        }

        return (hrp, Data(data.bytes.dropLast(6)))
    }

    static func createChecksum(hrp: Data, data: Data) -> Data {
        let values = hrpExpand(hrp) + data + [0, 0, 0, 0, 0, 0]
        let mod = polymod(values) ^ 1
        var ret = Data()
        for p in 0..<6 {
            ret.append(UInt8( (mod >> ((5 - p) * 5)) & 0x1f ))
        }
        return ret
    }

    static func verifyChecksum(hrp: String, data: Data) -> Bool {
        return polymod(hrpExpand(hrp.data(using: .utf8)!) + data) == 1
    }

    static func polymod(_ values: Data) -> Int {
        var chk = 1
        for p in 0..<values.count {
            let top = chk >> 25
            chk = (chk & 0x1ffffff) << 5 ^ Int(values[p])
            for i in 0..<5 {
                if (top >> i) & 1 > 0 {
                    chk ^= GENERATOR[i]
                }
            }
        }
        return chk
    }

    static func hrpExpand(_ hrp: Data) -> Data {
        var ret = Data()
        ret.append(contentsOf: hrp.map { $0 >> 5 })
        ret.append(0)
        ret.append(contentsOf: hrp.map { $0 & 31})
        return ret
    }
}
