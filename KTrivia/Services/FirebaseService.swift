//
//  AppDataService.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/8/22.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol DataService {
    func getGroups(completion: @escaping ([String]) -> Void)
}

class FirebaseService: DataService {
    private let db = Firestore.firestore()
    @Published var groups = [String]()
    
    func getGroups(completion: @escaping ([String]) -> Void) {
        db.collection("questions").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            
            self.groups = documents.map { (queryDocumentSnapshot) -> String in
                let data = queryDocumentSnapshot.data()
                let category = data["category"] as? String ?? ""
                return category
            }.removeDuplicates()
            
            completion(
                self.groups
            )
        }
    }
}
