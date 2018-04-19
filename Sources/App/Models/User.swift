//
//  User.swift
//  App
//
//  Created by Arkadiusz Banaś on 30/03/2018.
//

import Vapor
import FluentPostgreSQL

final class User: PostgreSQLModel {
    var username: String
    var avatarUrl: String
    var id: Int?

    init(username: String, avatarUrl: String) {
        self.username = username
        self.avatarUrl = avatarUrl
    }
}

extension User: Content { }
extension User: Migration { }
extension User: Parameter { }
