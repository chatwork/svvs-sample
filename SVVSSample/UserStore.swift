//
//  UserStore.swift
//  SVVSSample
//
//  Created by Yuta Koshizawa on 2023/08/15.
//

import Combine

@MainActor
final class UserStore {
    static let shared: UserStore = .init()

    @Published private(set) var values: [User.ID: User] = [:]

    func loadValue(for id: User.ID) async throws {
        if let value = try await UserRepository.fetchValue(for: id) {
            values[value.id] = value
        } else {
            values.removeValue(forKey: id)
        }
    }

    func loadValues(for ids: [User.ID]) async throws {
        var values = self.values
        let fetchedValues = try await UserRepository.fetchValues(for: ids)
        var idsToBeRemoved: Set<User.ID> = .init(ids)
        for value in fetchedValues {
            values[value.id] = value
            idsToBeRemoved.remove(value.id)
        }
        for id in idsToBeRemoved {
            values.removeValue(forKey: id)
        }
        self.values = values
    }

    func updateValue(_ value: User) async throws {
        try await UserRepository.updateValue(value)
        values[value.id] = value
    }

    func updateBookmarked(_ isBookmarked: Bool, for id: User.ID) async throws {
        try await UserRepository.updateBookmarked(isBookmarked, for: id)
        values[id]?.isBookmarked = isBookmarked
    }
}
