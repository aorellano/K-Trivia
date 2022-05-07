//
//  HomeListViewModel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 5/4/22.
//

import FirebaseFirestore
import SwiftUI

class HomeListViewModel: ObservableObject {
    @Published var games = [Game]()
    var dataService: DataService
    
    init(dataService: DataService = DataServiceImpl()) {
        self.dataService = dataService
    }
    
    func getGames(for user: String) {
        dataService.getUsersGameIds(for: user) { games in
            
            self.games = games.filter({$0.id != ""})
            print("Hello \(self.games)")
        }
    }
}
