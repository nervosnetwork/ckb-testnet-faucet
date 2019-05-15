//
//  AuthorizationService.swift
//  App
//
//  Created by 翟泉 on 2019/3/12.
//

import Foundation

class Authorization {
    enum Status: Int {
        case tokenIsVailable = 0
        case unauthenticated = -1
        case received = -2
    }

    func verify(accessToken: String?) -> Status {
        if let accessToken = accessToken {
            if let user = User.query(accessToken: accessToken) {
                if user.collectionDate?.timeIntervalSince1970 ?? 0 < Date().timeIntervalSince1970 - 24 * 60 * 60 {
                    return .tokenIsVailable
                } else {
                    return .received
                }
            } else {
                return .unauthenticated
            }
        } else {
            return .unauthenticated
        }
    }

    func authorization(code: String) -> String? {
        // Exchange this code for an access token
        guard let accessToken = GithubAPI.getAccessToken(code: code) else { return nil }
        let email = GithubAPI.getUserEmail(accessToken: accessToken)
        saveEmailCSV(email: email)
        var user: User
        if let result = User.query(accessToken: accessToken) {
            user = result
            user.authorizationDate = Date()
        } else {
            user = User(accessToken: accessToken, authorizationDate: Date(), collectionDate: nil)
        }
        try? user.save()
        return accessToken
    }

    func recordCollectionDate(accessToken: String) {
        if var user = User.query(accessToken: accessToken) {
            user.collectionDate = Date()
            try? user.save()
        }
    }

    private func saveEmailCSV(email: String?) {
        if let email = email {
            let time = getDataNow()
            let fileName = "email.csv"
            let newLine = "\(email),\(time)\n"
            let currentPath = FileManager.default.currentDirectoryPath
            let currentPathUrl = URL(fileURLWithPath: currentPath)
            let fileURL = currentPathUrl.appendingPathComponent(fileName)

            if FileManager.default.fileExists(atPath: currentPath + "/email.csv") {
                let fileHandle = FileHandle(forWritingAtPath: currentPath + "/email.csv")
                fileHandle?.seekToEndOfFile()
                fileHandle?.write(newLine.data(using: .utf8)!)
                fileHandle?.closeFile()
            } else {
                let csvText = "email,time\n" + newLine
                try? csvText.write(to: fileURL, atomically: false, encoding: .utf8)
            }
        }
    }

    private func getDataNow() -> String {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd 'at' HH:mm:ss.SSS"
        let nowTime = timeFormatter.string(from: date)
        return nowTime
    }
}
