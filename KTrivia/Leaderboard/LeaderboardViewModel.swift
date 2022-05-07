//
//  LeaderboardViewModel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 5/6/22.
//

import FirebaseFirestore

class LeaderboardViewModel: ObservableObject {
    @Published var users = [SessionUserDetails]()
    
    var dataService: DataService
    
    init(dataService: DataService = DataServiceImpl()) {
        self.dataService = dataService
    }
    
    
    func getUsers() {
        dataService.getUsers() { users in
            let sortedUsers = users.sorted(by: {$0.totalScore > $1.totalScore})
            self.users = sortedUsers
        }
    }
}


//get all users gameids
//"gdashgjkahsdg"
//"dksgjalgkj"
//"fhsjkhfsdk"

//get all games with those ids
//

//create totalScore for users
//everytime they complete the game add the score to their totalscore
//call users




//with the gameids retreive games
//calculate all scores

//get all games
//calculate all scores
