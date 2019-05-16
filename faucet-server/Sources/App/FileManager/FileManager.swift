//
//  FileManager.swift
//  App
//
//  Created by XiaoLu on 2019/5/16.
//

import Foundation

final class File {

    init() {

    }

    func importCSV() {
        let githubArray = GithubUserInfo.getAll()
        var csvText = "email,time\n"
        let fileName = "email-\(getDateNow()).csv"
        for githubInfo in githubArray {
            csvText += "\(githubInfo.email ?? ""),\(githubInfo.loginDate ?? "")\n"
        }
        let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let fileURL = currentDirectory.appendingPathComponent(fileName)
        try? csvText.write(to: fileURL, atomically: false, encoding: .utf8)
    }

    private func getDateNow() -> String {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd 'at' HH:mm:ss.SSS"
        let nowTime = timeFormatter.string(from: date)
        return nowTime
    }

}
