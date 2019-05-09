import Vapor
import CKB

/// Register your application's routes here.
public func routes(_ router: Router) throws {
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
