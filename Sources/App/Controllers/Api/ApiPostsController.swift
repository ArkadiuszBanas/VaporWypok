//
//  ApiPostsController.swift
//  App
//
//  Created by Arkadiusz Banaś on 01/04/2018.
//

import Vapor
import FluentProvider

struct ApiPostController {

    func addRoutes(to drop: Droplet) {
        let postGroup = drop.grouped("api", "posts")
        postGroup.get(handler: allPosts)
        postGroup.get(Post.parameter, handler: getPost)
    }

    func allPosts(_ req: Request) throws -> ResponseRepresentable {
        let users = try Post.all()
        return try users.makeJSON()
    }

    func getPost(_ req: Request) throws -> ResponseRepresentable {
        return try req.parameters.next(Post.self)
    }
}
