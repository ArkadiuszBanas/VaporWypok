//
//  ApiUsersController.swift
//  App
//
//  Created by Arkadiusz Banaś on 01/04/2018.
//

import Vapor
import Fluent

struct ApiUsersController {

    func addRoutes(to router: Router) {
        router.get("api", "users", use: allUsers)
    }

    func allUsers(_ req: Request) -> Future<[User]> {
        return User.query(on: req).all()
    }
}
