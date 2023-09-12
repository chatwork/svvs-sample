//
//  UserViewStateTests.swift
//  SVVSSampleTests
//
//  Created by CHEEBOW on 2023/09/07.
//

import XCTest
@testable import SVVSSample

@MainActor
final class UserViewStateTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    private func sleep() async throws {
        try await Task.sleep(nanoseconds: 600_000_000)
    }

    func testFriends() async throws {
        let stateA = UserViewState(id: "A")
        await stateA.onAppear()
        try await sleep()
        XCTAssertEqual(stateA.filteredFriends.keys, ["B", "C", "D"])

        let stateB = UserViewState(id: "B")
        await stateB.onAppear()
        try await sleep()
        XCTAssertEqual(stateB.filteredFriends.keys, ["A", "C"])

        let stateC = UserViewState(id: "C")
        await stateC.onAppear()
        try await sleep()
        XCTAssertEqual(stateC.filteredFriends.keys, ["A", "B"])

        let stateD = UserViewState(id: "D")
        await stateD.onAppear()
        try await sleep()
        XCTAssertEqual(stateD.filteredFriends.keys, ["A"])
    }

    func testOnlyBookmarked() async throws {
        let stateA = UserViewState(id: "A")
        await stateA.onAppear()
        try await sleep()
        XCTAssertEqual(stateA.filteredFriends.keys, ["B", "C", "D"])

        await stateA.toggleFriendBookmark(for: "B") // "B".isBookmarked = true
        try await sleep()
        XCTAssertEqual(stateA.filteredFriends.keys, ["B", "C", "D"])

        stateA.showsOnlyBookmarkedFriends = true
        XCTAssertEqual(stateA.filteredFriends.keys, ["B"])

        await stateA.toggleFriendBookmark(for: "B") // "B".isBookmarked = false
        try await sleep()
        XCTAssertEqual(stateA.filteredFriends.keys, [])

        stateA.showsOnlyBookmarkedFriends = false
        XCTAssertEqual(stateA.filteredFriends.keys, ["B", "C", "D"])
    }
}
