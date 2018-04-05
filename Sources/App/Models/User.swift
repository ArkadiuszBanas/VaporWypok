//
//  User.swift
//  App
//
//  Created by Arkadiusz Banaś on 30/03/2018.
//

import Vapor
import FluentProvider

final class User: Model {
    var storage = Storage()
    var username: String
    var avatarUrl: String

    init(username: String, avatarUrl: String) {
        self.username = username
        self.avatarUrl = avatarUrl
    }

    func makeRow() throws -> Row {
        var row = Row()
        try row.set("username", username)
        try row.set("avatarUrl", avatarUrl)
        return row
    }

    init(row: Row) throws {
        self.username = try row.get("username")
        self.avatarUrl = try row.get("avatarUrl")
    }
}

// MARK: Fluent Preparation
extension User: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("username")
            builder.string("avatarUrl")
        }
    }
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: Node
extension User: NodeRepresentable {
    func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set("id", id)
        try node.set("username", username)
        try node.set("avatarUrl", avatarUrl)
        return node
    }
}

// MARK: JSON
extension User: JSONConvertible, ResponseRepresentable {

    convenience init(json: JSON) throws {
        try self.init(username: json.get("username"), avatarUrl: json.get("avatarUrl"))
    }

    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("id", id)
        try json.set("username", username)
        try json.set("avatarUrl", avatarUrl)
        try json.set("posts", Post.makeQuery().filter("user_id", .equals, self.id).all())
        return json
    }
}
