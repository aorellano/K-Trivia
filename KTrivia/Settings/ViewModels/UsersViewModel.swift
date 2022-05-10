//
//  LeaderboardViewModel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 5/6/22.
//

import FirebaseFirestore
import FirebaseAuth

class UsersViewModel: ObservableObject {
    @Published var users = [SessionUserDetails]()
    @Published var filteredUsers = [SessionUserDetails]()
    @Published var friends = [[String:String]]()
    
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
    
    func getFriends()  {
        let user = Auth.auth().currentUser?.uid
        dataService.getFriends(for: user ?? "") { friends in
            //let sortedUsers = users.sorted(by: {$0.totalScore > $1.totalScore})
            print("hiii\(friends)")
            self.friends = friends
        }
    }
    
    func search(with query: String) {
        self.getUsers()
        filteredUsers = users.filter { $0.username.contains(query) }
    }
    
    func addFriend(to user: [String:String], with id: [String:String]) {
        dataService.addFriend(to: user, with: id)
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
