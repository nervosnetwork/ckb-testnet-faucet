import Vapor

/// Called after your application has initialized.
public func boot(_ app: Application) throws {
    let clientid = try app.environment.commandInput.parse(option: .value(name: "github_oauth_clientid")) ?? ""
    let clientSecret  = try app.environment.commandInput.parse(option: .value(name: "github_oauth_secret")) ?? ""
    GithubOAuth.config(clientId: clientid, clientSecret: clientSecret)
}
