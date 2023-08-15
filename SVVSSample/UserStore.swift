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
        let values = try await UserRepository.fetchValues(for: ids)
        for value in values {
            self.values[value.id] = value
        }
    }

    func updateValue(_ value: User) async throws {
        values[value.id] = value
        try await UserRepository.updateValue(value)
    }
}
