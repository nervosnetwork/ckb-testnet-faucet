//
//  FaucetResponseModel.swift
//  App
//
//  Created by 翟泉 on 2019/5/28.
//

import Foundation
import Vapor

struct FaucetResponseContent: Content {
    let txHash: String
}
