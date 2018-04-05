//
//  ApiUsersController.swift
//  App
//
//  Created by Arkadiusz Banaś on 01/04/2018.
//

import Vapor
import FluentProvider

struct ApiUsersController {

    func addRoutes(to drop: Droplet) {
        let usersGroup = drop.grouped("api", "users")
        usersGroup.get(handler: allUsers)
        usersGroup.get(User.parameter, handler: getUser)
    }

    func allUsers(_ req: Request) throws -> ResponseRepresentable {
        let users = try User.all()
        return try users.makeJSON()
    }

    func getUser(_ req: Request) throws -> ResponseRepresentable {
        return try req.parameters.next(User.self)
    }
}
