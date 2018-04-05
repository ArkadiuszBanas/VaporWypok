//
//  Post.swift
//  App
//
//  Created by Arkadiusz Banaś on 30/03/2018.
//

import Vapor
import FluentProvider

final class Post: Model {
    var storage = Storage()
    var text: String
    let userId: Identifier?

    init(text: String, user: User) {
        self.text = text
        self.userId = user.id
    }

    func makeRow() throws -> Row {
        var row = Row()
        try row.set("text", text)
        try row.set(User.foreignIdKey, userId)
        return row
    }

    init(row: Row) throws {
        self.text = try row.get("text")
        userId = try row.get(User.foreignIdKey)
    }
}

// Mark: Relations
extension Post {
    var user: Parent<Post, User> {
        return parent(id: userId)
    }
}

// MARK: Fluent Preparation
extension Post: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("text")
            builder.parent(User.self)
        }
    }
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: Node
extension Post: NodeRepresentable {
    func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set("id", id)
        try node.set("text", text)
        try node.set("text_lines", text_lines)
        try node.set("user", User.find(userId))
        return node
    }
}

// MARK: JSON
extension Post: JSONConvertible, ResponseRepresentable {

    convenience init(json: JSON) throws {
        let userId: Identifier = try json.get("user_id")
        guard let user = try User.find(userId) else {
            throw Abort.badRequest
        }

        try self.init(text: json.get("text"), user: user)
    }

    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("text", text)
        try json.set("user_id", userId)
        return json
    }
}

extension Post {
    var text_lines: [String] {
        return text.components(separatedBy: "\n")
    }
}
