//
//  UserRepository.swift
//  SVVSSample
//
//  Created by Yuta Koshizawa on 2023/08/15.
//

private var values: [User.ID: User] = [
    "A": User(id: "A", name: "UserA", friendIDs: ["B", "C", "D"], isBookmarked: false),
    "B": User(id: "B", name: "UserB", friendIDs: ["A", "C"], isBookmarked: false),
    "C": User(id: "C", name: "UserC", friendIDs: ["A", "B"], isBookmarked: false),
    "D": User(id: "D", name: "UserD", friendIDs: ["A"], isBookmarked: false),
]

enum UserRepository {
    static func fetchValue(for id: User.ID) async throws -> User? {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return values[id]
    }

    static func fetchValues(for ids: [User.ID]) async throws -> [User] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return ids.compactMap { id in values[id] }
    }

    static func updateValue(_ value: User) async throws {
        values[value.id] = value
    }
}
