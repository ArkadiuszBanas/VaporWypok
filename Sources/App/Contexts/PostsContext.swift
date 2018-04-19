//
//  PostsViewModel.swift
//  App
//

import Vapor
import Fluent

private struct PostsConstant {
    static let pageSize = 10
    static let buttonsLimit = 10
    static let previousTitle = "Poprzednia"
    static let nextTitle = "Następna"
}

struct PostContext: Encodable {
    let user: Future<User>
    let text: String

    init(post: Post, request: DatabaseConnectable) throws {
        self.user = try post.user.get(on: request)
        self.text = post.text // text.components(separatedBy: "\n")
    }
}

struct NavigationButton: Encodable {

    let isActive: Bool
    let url: String
    let title: String
}

struct PostsContext: Encodable {

    let pageNumber: Int
    let postContexts: [PostContext]
    let base: BaseContext

    private let posts: [Post]

//    var navigationButtons: [NavigationButton] {
//
//        do {
//            var buttons = [NavigationButton]()
//            let postsCount = try Post.count()
//            let pagesCount = postsCount / PostsConstant.pageSize
//
//            // Add 'previous' button
//            if pageNumber > 0 {
//                buttons.append(NavigationButton(isActive: false, url: "/\(pageNumber - 1)", title: PostsConstant.previousTitle))
//            }
//
//            // Add current button
//            buttons.append(NavigationButton(isActive: true, url: "/\(pageNumber)", title: String(pageNumber + 1)))
//
//            // Add next buttons
//            var nextButtonPage = pageNumber
//            while buttons.count < PostsConstant.buttonsLimit - 1 && nextButtonPage < pagesCount - 1 {
//                nextButtonPage += 1
//                buttons.append(NavigationButton(isActive: false, url: "/\(nextButtonPage)", title: String(nextButtonPage + 1)))
//            }
//
//            // Add 'next' button
//            if pageNumber + 1 < pagesCount {
//                buttons.append(NavigationButton(isActive: false, url: "/\(pageNumber + 1)", title: PostsConstant.nextTitle))
//            }
//
//            return buttons
//
//        } catch _ {
//            print("Problem with accessing Post model in database")
//        }
//    }

    init(pageNumber: Int, posts: [Post], base: BaseContext, request: DatabaseConnectable) throws {
        self.pageNumber = pageNumber
        self.posts = posts
        self.base = base
        
        try self.postContexts = posts.map {
            return try PostContext(post: $0, request: request)
        }
    }
}
