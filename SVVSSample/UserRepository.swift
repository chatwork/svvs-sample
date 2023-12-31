//
//  UserRepository.swift
//  SVVSSample
//
//  Created by Yuta Koshizawa on 2023/08/15.
//

enum UserRepository {
    static func fetchValue(for id: User.ID) async throws -> User? {
        try await Task.sleep(nanoseconds: 500_000_000)
        return try await Backend.shared.value(for: id)
    }

    static func fetchValues(for ids: [User.ID]) async throws -> [User] {
        try await Task.sleep(nanoseconds: 500_000_000)
        return try await ids.compactMap { id in try await Backend.shared.value(for: id) }
    }

    static func updateValue(_ value: User) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
        try await Backend.shared.setValue(value)
    }

    static func updateBookmarked(_ isBookmarked: Bool, for id: User.ID) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
        try await Backend.shared.updateBookmarked(isBookmarked, for: id)
    }

    // Simulated backend
    private actor Backend {
        static let shared: Backend = .init()

        var values: [User.ID: User] = [
            "A": User(id: "A", name: "UserA", friendIDs: ["B", "C", "D"], isBookmarked: false),
            "B": User(id: "B", name: "UserB", friendIDs: ["A", "C"], isBookmarked: false),
            "C": User(id: "C", name: "UserC", friendIDs: ["A", "B"], isBookmarked: false),
            "D": User(id: "D", name: "UserD", friendIDs: ["A"], isBookmarked: false),
        ]

        func value(for id: User.ID) async throws -> User? {
            return values[id]
        }

        func setValue(_ value: User) async throws {
            values[value.id] = value
        }

        func updateBookmarked(_ isBookmarked: Bool, for id: User.ID) async throws {
            values[id]?.isBookmarked = isBookmarked
        }
    }
}

private extension Sequence {
    func compactMap<T>(_ transform: (Element) async throws -> T?) async rethrows -> [T] {
        var result: [T] = []
        for element in self {
            guard let transformed = try await transform(element) else { continue }
            result.append(transformed)
        }
        return result
    }
}
