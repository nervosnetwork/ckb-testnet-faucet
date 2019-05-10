import Vapor

public class App {
    private var app: Application!

    public init(_ env: Environment) throws {
        var config = Config.default()
        var env = env
        var services = Services.default()
        try configure(&config, &env, &services)
        app = try Application(config: config, environment: env, services: services)
    }

    public func run() throws {
        try app.run()
    }

    private func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
        // Register routes to the router
        let router = EngineRouter.default()
        try setupRoutes(router)
        services.register(router, as: Router.self)

        // Register middleware
        var middlewares = MiddlewareConfig() // Create _empty_ middleware config
        // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
        middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
        services.register(middlewares)

        try Environment.Process.configure(&env)
    }

    private func setupRoutes(_ router: Router) throws {
        // Basic "It works" example
        router.get { req in
            return "It works!"
        }

        // Basic "Hello, world!" example
        router.get("hello") { req in
            return "Hello, world!"
        }

        try router.register(collection: AuthorizationController())
        try router.register(collection: CKBController())
    }

}
