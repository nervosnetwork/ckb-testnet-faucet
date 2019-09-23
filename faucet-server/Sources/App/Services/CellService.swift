//
//  CellService.swift
//  App
//
//  Created by 翟泉 on 2019/5/14.
//

import Foundation

final class CellService {
    private static let savePath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath + "/block_number")

    static func saveBlockNumber(_ blockNumber: UInt64, for key: String) {
        var blockNumberOfLockHash: [String: UInt64]
        do {
            let data = try Data(contentsOf: savePath)
            blockNumberOfLockHash = try JSONDecoder().decode([String: UInt64].self, from: data)
        } catch {
            blockNumberOfLockHash = [:]
        }
        blockNumberOfLockHash[key] = blockNumber
        try? JSONEncoder().encode(blockNumberOfLockHash).write(to: savePath)
    }

    static func readBlockNumber(for key: String) -> UInt64 {
        do {
            let data = try Data(contentsOf: savePath)
            let blockNumberOfLockHash = try JSONDecoder().decode([String: UInt64].self, from: data)
            return blockNumberOfLockHash[key, default: 0]
        } catch {
            return 0
        }
    }
}
