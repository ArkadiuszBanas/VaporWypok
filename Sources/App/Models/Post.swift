//
//  Post.swift
//  App
//
//  Created by Arkadiusz Banaś on 30/03/2018.
//

import Vapor
import FluentPostgreSQL

final class Post: PostgreSQLModel {
    var text: String
    var userId: Int
    var id: Int?

    init(text: String, userId: User.ID) {
        self.text = text
        self.userId = userId
    }
}

// Mark: Relations
extension Post {
    var user: Parent<Post, User> {
        return parent(\.userId)
    }
}

extension Post: Migration { }
extension Post: Content { }
extension Post: Parameter { }
