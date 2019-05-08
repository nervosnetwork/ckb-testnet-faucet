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


//    let accessToken = "nananana"
//    var user = User(accessToken: accessToken, authorizationDate: Date(), collectionDate: nil)
//    user.save()
//
//    let us = User.query(accessToken: accessToken)
//    print(us)
//
////    XCTAssertEqual(user, us)
//
//    user.collectionDate = Date()
//    user.save()
////    XCTAssert(User.query(accessToken: accessToken)?.collectionDate != nil)


    try router.register(collection: AuthorizationController())
    try router.register(collection: CKBController())

}


func tests() {
    do {

        //        print(CKBService.generatePrivateKey())

        let api = APIClient()
        print(try api.getTipBlockNumber())

        let aws = try AlwaysSuccessWallet(api: api)
        print(try aws.getBalance())

        //        let tx = try api.getTransaction(hash: "0x79d84708837eb9573ab32e46614fb1ff2979a78333beb7e5a0ead945cd41d8b2")
        let tx = try api.getTransaction(hash: "0x9a46fc47a4fbb6b155d46e26311a011d40f13a377e3f97084b45c856ffd29e9d")
        print(tx)



        let wallet1 = try Wallet(api: api, privateKey: "81594894bbec5ea30944b19c196446d917933868d464c9903d9a9c53f65f8564")
        //        let txhash = try aws.sendCapacity(targetLock: wallet1.lock, capacity: 40400)
        //        print(txhash) // 0x51ec035f0c540979e22e86058cdc381b20889cf015159ffd959a306734608460
        //         0x39e00c72210879c89977da1cdd0176a5c14ed61900048b296efc7dd9df768d29
        print(try wallet1.getBalance())


        let wallet2 = try Wallet(api: api, privateKey: "b7a5e163e4963751ed023acfc2b93deb03169b71a4abe3d44abf4123ff2ce2a3")
        //        let txhash = try wallet1.sendCapacity(targetLock: wallet2.lock, capacity: 2800)
        //        print(txhash) // 0x79d84708837eb9573ab32e46614fb1ff2979a78333beb7e5a0ead945cd41d8b2
        //        // 0x9a46fc47a4fbb6b155d46e26311a011d40f13a377e3f97084b45c856ffd29e9d
        print(try wallet2.getBalance())


    } catch {
        print(error)
    }
}
