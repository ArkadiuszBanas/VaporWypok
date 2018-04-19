//
//  PostsController.swift
//  App
//
//  Created by Arkadiusz Banaś on 05/04/2018.
//

import Vapor
import Fluent

struct PostsController {

    func addRoutes(to router: Router) {
        router.get("/", use: showAllPosts)
        router.get("/", Int.parameter, use: showSpecificPageOfPosts)
        router.get("prepare", use: prepare)
        router.post("/", use: createPost)
    }

    func showAllPosts(_ req: Request) throws -> Future<View> {

        return try self.fetch(page: 0, on: req, completion: { (posts, user) -> Future<View> in
            let baseContext = BaseContext(user: user)
            let viewModel = try PostsContext(pageNumber: 0, posts: posts, base: baseContext, request: req)
            return try req.view().render("posts", viewModel)
        })
    }

    func prepare(_ req: Request) throws -> String {

        FakeContentHelper.generate(req: req)
        return "OK"
    }

    func showSpecificPageOfPosts(_ req: Request) throws -> Future<View> {
        let page = try req.parameter(Int.self)

        return try self.fetch(page: page, on: req, completion: { (posts, user) -> (Future<View>) in
            let baseContext = BaseContext(user: user)
            let viewModel = try PostsContext(pageNumber: page, posts: posts, base: baseContext, request: req)
            return try req.view().render("posts", viewModel)
        })
    }

    func createPost(_ req: Request) throws -> Future<View> {

        let text = try req.query.get(String.self, at: "body")

        return User.query(on: req).first().flatMap(to: View.self) { user in
            if let userId = user?.id {
                let post = Post(text: text, userId: userId)
                _ = post.save(on: req)
            }
            return try self.showAllPosts(req)
        }
    }


    typealias PostsFetchCompletion = ((_ posts: [Post], _ user: User?) throws -> (Future<View>))

    private func fetch(page: Int, on request: Request, completion: @escaping PostsFetchCompletion) throws -> Future<View> {

        return User.query(on: request).first().flatMap(to: View.self) { user in
            return try Post.query(on: request)
                .sort(\.id, .descending)
                .all()
                .flatMap(to: View.self) { posts in
                    return try completion(posts, user)
            }
        }
    }
}
