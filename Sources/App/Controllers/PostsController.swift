//
//  PostsController.swift
//  App
//
//  Created by Arkadiusz Banaś on 05/04/2018.
//

import Vapor
import FluentProvider

struct PostsController {

    let drop: Droplet

    init(drop: Droplet) {
        self.drop = drop
    }

    func addRoutes(to drop: Droplet) {
        drop.get("/", handler: showAllPosts)
        drop.post("/", handler: createPost)
        drop.get("/", Int.parameter, handler: showSpecificPageOfPosts)
        drop.get("/prepare", handler: prepare)
    }

    func showAllPosts(_ req: Request) throws -> ResponseRepresentable {
        let viewModel = try PostsViewModel(pageNumber: 0)

        guard viewModel.posts.count > 0 else {
            return Response(redirect: "prepare")
        }

        return try drop.view.make("posts", ["viewModel": viewModel])
    }

    func showSpecificPageOfPosts(_ req: Request) throws -> ResponseRepresentable {
        let page = try req.parameters.next(Int.self)
        let viewModel = try PostsViewModel(pageNumber: page)

        return try drop.view.make("posts", ["viewModel": viewModel])
    }

    func createPost(_ req: Request) throws -> ResponseRepresentable {
        guard let text = req.data["body"]?.string else {
            return Response(status: .badRequest)
        }

        if let user = try UserManager.shared.user() {
            let post = Post(text: text, user: user)
            try post.save()
        }

        return Response(redirect: "/")
    }

    func prepare(_ req: Request) throws -> ResponseRepresentable {
        try FakeContentHelper.generate()
        return Response(redirect: "/")
    }
}
