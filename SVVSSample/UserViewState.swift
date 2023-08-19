//
//  UserViewState.swift
//  SVVSSample
//
//  Created by Yuta Koshizawa on 2023/08/15.
//

import Combine

@MainActor
final class UserViewState: ObservableObject {
    let id: User.ID

    @Published private(set) var user: User?
    @Published private(set) var friends: [User] = []

    @Published var showsOnlyBookmarkedFriends: Bool = false

    private var cancellables: Set<AnyCancellable> = []

    init(id: User.ID) {
        self.id = id

        UserStore.shared.$values.map { $0[id] }.removeDuplicates().assign(to: &$user)

        $user.combineLatest(UserStore.shared.$values).map { user, users in
            guard let user else { return [] }
            return user.friendIDs.compactMap { friendID in users[friendID] }
        }
        .removeDuplicates()
        .assign(to: &$friends)

        $user.sink { user in
            guard let user else { return }
            Task {
                do {
                    try await UserStore.shared.loadValues(for: user.friendIDs)
                } catch {
                    // TODO: Error Handling
                    print(error)
                }
            }
        }
        .store(in: &cancellables)
    }

    func onAppear() async {
        do {
            try await UserStore.shared.loadValue(for: id)
        } catch {
            // TODO: Error Handling
            print(error)
        }
    }

    func toggleFriendBookmark(_ friend: User) async {
        var friend = friend
        friend.isBookmarked.toggle()
        do {
            try await UserStore.shared.updateValue(friend)
        } catch {
            // TODO: Error Handling
            print(error)
        }
    }
}
