//
//  PostsViewModel.swift
//  App
//

import Vapor

private struct PostsConstant {
    static let pageSize = 10
    static let buttonsLimit = 10
    static let previousTitle = "Poprzednia"
    static let nextTitle = "Następna"
}

struct PostsViewModel {

    let posts: [Post]
    let pageNumber: Int

    var navigationButtons: [NavigationButton] {

        do {
            var buttons = [NavigationButton]()
            let postsCount = try Post.count()
            let pagesCount = postsCount / PostsConstant.pageSize

            // Add 'previous' button
            if pageNumber > 0 {
                buttons.append(NavigationButton(isActive: false, url: "/\(pageNumber - 1)", title: PostsConstant.previousTitle))
            }

            // Add current button
            buttons.append(NavigationButton(isActive: true, url: "/\(pageNumber)", title: String(pageNumber + 1)))

            // Add next buttons
            var nextButtonPage = pageNumber
            while buttons.count < PostsConstant.buttonsLimit - 1 && nextButtonPage < pagesCount - 1 {
                nextButtonPage += 1
                buttons.append(NavigationButton(isActive: false, url: "/\(nextButtonPage)", title: String(nextButtonPage + 1)))
            }

            // Add 'next' button
            if pageNumber + 1 < pagesCount {
                buttons.append(NavigationButton(isActive: false, url: "/\(pageNumber + 1)", title: PostsConstant.nextTitle))
            }

            return buttons

        } catch _ {
            print("Problem with accessing Post model in database")
        }

        return []
    }

    init(pageNumber: Int) throws {

        let offset = PostsConstant.pageSize * pageNumber
        self.posts = try Post.makeQuery()
            .sort("id", .descending)
            .limit(PostsConstant.pageSize, offset: offset).all()
        self.pageNumber = pageNumber
    }
}

extension PostsViewModel: NodeRepresentable {

    func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set("posts", posts)
        try node.set("navigation_buttons", navigationButtons)
        try node.set("show_navigation_buttons", navigationButtons.count > 0)
        try node.set("user", UserManager.shared.user())
        return node
    }
}

struct NavigationButton: NodeRepresentable {

    let isActive: Bool
    let url: String
    let title: String

    func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set("is_active", isActive)
        try node.set("url", url)
        try node.set("title", title)
        return node
    }
}

