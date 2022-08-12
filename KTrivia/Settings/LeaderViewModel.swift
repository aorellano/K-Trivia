//
//  LeaderViewModel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 8/11/22.
//

import Foundation

class LeaderViewModel: ObservableObject {
    @Published var users = [SessionUserDetails]()
    
    var service: UsersService
    
    init(service: UsersService = UsersServiceImpl()) {
        self.service = service
    }
    
    @MainActor
    func getUsers()  {
        Task.init {
            users = try await service.getUsers()
        }
    }
}
