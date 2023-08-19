//
//  User.swift
//  SVVSSample
//
//  Created by Yuta Koshizawa on 2023/08/15.
//

import SwiftID

struct User: Sendable, Identifiable, Hashable {
    let id: ID
    var name: String
    var friendIDs: [User.ID]
    var isBookmarked: Bool

    struct ID: StringIDProtocol {
        var rawValue: String
        init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}
