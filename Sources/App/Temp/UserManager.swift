//
//  UserManager.swift
//  App
//
//  Created by Arkadiusz Banaś on 03/04/2018.
//

import Foundation

/*
    Class created just for imitating logged user.
    Will be removed as soon as account creation will be implemented.
*/

class UserManager {

    static let shared = UserManager()

    func user() throws -> User? {
        return try User.find(1)
    }
}
