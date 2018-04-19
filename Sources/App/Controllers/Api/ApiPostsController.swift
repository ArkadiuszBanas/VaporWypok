//
//  ApiPostsController.swift
//  App
//
//  Created by Arkadiusz Banaś on 01/04/2018.
//

import Vapor
import Fluent

struct ApiPostController {

    func addRoutes(to router: Router) {
        router.get("api", "posts", use: allPosts)
    }

    func allPosts(_ req: Request) -> Future<[Post]> {
        return Post.query(on: req).all()
    }
}
