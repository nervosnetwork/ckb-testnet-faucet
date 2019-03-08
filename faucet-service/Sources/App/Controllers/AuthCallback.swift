//
//  GithubAuthCallback.swift
//  App
//
//  Created by 翟泉 on 2019/3/7.
//

import Foundation
import Vapor
import SQLite

func authCallback(_ req: Request) -> Response {
    let parameters = req.http.url.absoluteString.urlParametersDecode
    guard let code = parameters["code"], let state = parameters["state"] else {
        return Response(http: HTTPResponse(status: HTTPResponseStatus(statusCode: 404)), using: req)
    }

    // Get access token
    let accessToken = requestAccessToken(code: code)

    // Redirect back to Web page
    let headers = HTTPHeaders([("Location", state)])

    var http = HTTPResponse(status: HTTPResponseStatus(statusCode: 302), headers: headers)

    // If the validation is successful, Add access token Cookie
    if let accessToken = accessToken {
        let domain = URL(string: state)?.host
        http.cookies = HTTPCookies(
            dictionaryLiteral: (AccessTokenCookieName, HTTPCookieValue(string: accessToken, domain: domain))
        )
    }

    return Response(http: http, using: req.sharedContainer)
}
