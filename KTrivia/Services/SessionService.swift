//
//  SessionService.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/17/22.
//

import Foundation
import Combine
import Firebase
import FirebaseFirestore
import FirebaseAuth

enum SessionState {
    case loggedIn
    case loggedOut
}

protocol SessionService {
    var state: SessionState { get }
    var userDetails: SessionUserDetails? { get }
    func logout()
}

final class SessionServiceImpl: ObservableObject, SessionService {
    @Published var state: SessionState = .loggedOut
    @Published var userDetails: SessionUserDetails?
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        setupFirebaseHandler()
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
}

private extension SessionServiceImpl {
    func setupFirebaseHandler() {
        handler = Auth.auth()
            .addStateDidChangeListener{ [weak self] res, user in
                guard let self = self else { return }
                self.state = user == nil ? .loggedOut : .loggedIn
                if let uid = user?.uid {
                    self.handleRefresh(with: uid)
                }
            }
    }
    
    func handleRefresh(with uid: String) {
        Firestore
            .firestore()
            .collection("users")
            .document(uid)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(String(describing: error))")
                    return
                }
                guard let data = document.data() else {
                    print("Document Data was empty.")
                    return
                }
                guard let username = data["username"] as? String else {
                    return
                }
                
          
                
                guard let profilePic = data["profilePicUrl"] as? String else {
                    return
                }
                
                guard let games = data["games"] as? [String] else {
                    return
                }
                
                guard let totalScore = data["totalScore"] as? Double else {
                    return
                }
                
                guard let friends = data["friends"] as? [[String: String]] else {
                    return
                }
                print(friends)
                
                DispatchQueue.main.async {
                    
                    self.userDetails = SessionUserDetails(id: uid, username: username, profilePic: profilePic, games: games, totalScore: totalScore, friends: friends)
                    print(self.userDetails)
                }
            }
    }
}
