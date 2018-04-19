//
//  FakeContentHelper.swift
//  App
//
//  Created by Arkadiusz Banaś on 31/03/2018.
//

import Foundation
import Vapor

/*
    Class is generating random posts for development purposes.
    Will be removed as soon as connection to MySQL will be implemented.
*/

class FakeContentHelper {

    static func generate(req: Request) {
        FakeContentHelper.generateUsers(req)
        FakeContentHelper.generatePosts(count: 140, req: req)
    }

    static func generatePosts(count: Int, req: Request) {
        let p1 = "Gdybym dostawał złotówkę za każdą kobietę, której się nie podobam, to w końcu zacząłbym im się podobać."
        let p2 = "<m4tt> wiesz.. 67% dziewczyn nie uzywa mozgu\n<funky_girl> ja naleze do tych 13 %"
        let p3 = "<xxx> Pomorze ktos?\n<Unf> Niestety, mazowsze."
        let p4 = "<absinth> omg\n<absinth> moj stary przeszedl cale call of duty\n<misiek> co w tym zlego lub dziwnego?\n<absinth> ta, ale on w przedostaniej misji sie mnieu pyta czy mozna colta na inna bron zmienic"
        let p5 = "-ale nie mam prawka jeszcze, więc mama daje mi tylko w lesie\n-i na mało uczęszczanych drogach"
        let p6 = "Poszedlem z nudow na wyklad a tam kolokwium"
        let p7 = "<sor> Odpowiedzi zaznaczajcie ptaszkiem.\n<glos z sali> A długopisem można?"
        let texts = [p1, p2, p3, p4, p5, p6, p7]

        for _ in 1...count {
            let text = texts.randomItem() ?? ""
            let userId = Int.wypok_generateRandom(max: count)
            _ = Post(text: text, userId: userId).save(on: req)
        }
    }

    private static func generateUsers(_ req: Request) {

        ["m_b", "Elfik", "Tobol", "tomkowz_runner", "janusz", "anon", "mirek", "never_settle"].forEach {
            let avatarNumber = Int.wypok_generateRandom(max: 7) + 1
            let avatarUrl = "/images/temp/av_\(avatarNumber).jpg"

            _ = User(username: $0, avatarUrl: avatarUrl).create(on: req)
        }
    }
}

private extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int.wypok_generateRandom(max: self.count)
        return self[index]
    }
}
