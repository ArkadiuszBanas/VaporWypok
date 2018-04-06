//
//  BaseViewModel.swift
//  App
//
//  Created by Arkadiusz Banaś on 06/04/2018.
//

import Vapor
import LeafProvider

struct BaseViewModel: NodeRepresentable {

    func makeNode(in context: Context?) throws -> Node {
        var node = Node(context)
        try node.set("user", UserManager.shared.user())
        return node
    }
}
