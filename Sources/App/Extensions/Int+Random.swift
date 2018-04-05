//
//  Int+Random.swift
//  App
//
//  Created by Arkadiusz Banaś on 05/04/2018.
//

import Foundation

extension Int {

    static func wypok_generateRandom(max: Int) -> Int {
#if os(Linux)
        return Int(random() % (max + 1))
#else
        return Int(arc4random_uniform(UInt32(max)))
#endif
    }
}
