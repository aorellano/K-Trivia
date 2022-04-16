//
//  RegistrationService.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/16/22.
//

import Combine
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SwiftUI

protocol RegistrationService {
    func register(with details: RegistrationDetails, and profilePicture: UIImage) -> AnyPublisher<Void, Error>
}

final class RegistrationServiceImpl: ObservableObject, RegistrationService {
    func register(with details: RegistrationDetails, and profilePicture: UIImage) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                Auth
                    .auth()
                    .createUser(withEmail: details.email, password: details.password) { [self] res, error in
                        print("This is the password\(details.password)")
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            if let uid = res?.user.uid {
                                print("Successfully created user: \(uid)")
                                self.storeProfilePic(with: uid, details, and: profilePicture)
                                //self.storeUsers(uid, details, profilePic)
                                
                            } else {
                                promise(.failure(NSError(domain: "Invalid User Id", code: 0, userInfo: nil)))
                            }
                        }
                    }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    func storeUsers(_ uid: String, _ details: RegistrationDetails, _ profilePic: String) {
        let userData = ["uid": uid, "username": details.username, "email": details.email, "profilePicUrl": profilePic]
        Firestore
            .firestore()
            .collection("users")
            .document(uid).setData(userData) { error in
                if let err = error {
                    print(err)
                    return
                }
            }
        print("User details saved!")
    }
    
    func storeProfilePic(with uid: String, _ details: RegistrationDetails, and image: UIImage) {
        let ref = Storage.storage().reference(withPath: uid)
        let imageData = image.jpegData(compressionQuality: 0.5)!
                ref.putData(imageData, metadata: nil) { metadata, err in
                    if let err = err {
                        print("Failed to push image to storage \(err)")
                        return
                    }
                    
                    ref.downloadURL { url, err in
                        if let err = err {
                            print("Failed to retreive downloadURL \(err)")
                            return
                        }
                        
                        let profilePic = url?.absoluteString ?? ""
                        self.storeUsers(uid, details, profilePic)
                        print("Successfully stored image with url: \(url?.absoluteString ?? "")")
                    }
                }
    }
}


//do {
//    try db.collection("game").document(self.game.id).setData([
//        "id": self.game.id,
//        "player1Id": self.game.player1Id,
//        "player2Id": self.game.player2Id,
//        "player1Score": score,
//        "player2Score": self.game.player2Score,
//        "winnerPlayerId": self.game.winnerPlayerId
//
//    ])
//
//
//
//}
