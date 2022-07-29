//
//  LeaderboardViewModel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 5/6/22.
//

import FirebaseFirestore
import FirebaseAuth

class FriendsViewModel: ObservableObject {
    @Published var users = [SessionUserDetails]()
    @Published var filteredUsers = [SessionUserDetails]()
    @Published var friends = [[String:String]]()
    
    var service: UsersService
    
    init(service: UsersService = UsersServiceImpl()) {
        self.service = service
    }
    
    @MainActor
    func getFriends(for user: SessionUserDetails)  {
        Task.init {
            friends = try await service.getFriends(for: user.id)
        }
    }
    
    @MainActor
    func search(for username: String) {
        Task.init {
            users = try await service.getUsers(with: username)
        }
    }
    
    func addFriend(to user: SessionUserDetails, with friend: SessionUserDetails) {
        service.addFriend(to: user, with: friend)
    }
}
