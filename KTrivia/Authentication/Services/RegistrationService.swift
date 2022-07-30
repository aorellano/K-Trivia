//
//  RegistrationService.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/16/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SwiftUI
import Combine

enum RegistrationKeys: String {
    case username
    case email
    case profilePicUrl
    case totalScore
    case games
    case friends
}

protocol RegistrationService {
    func register(with details: RegistrationDetails, and profilePicture: UIImage) -> AnyPublisher<Void, Error>
}

final class RegistrationServiceImpl: ObservableObject, RegistrationService {
    func register(with details: RegistrationDetails, and profilePicure: UIImage) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                Auth.auth().createUser(withEmail: details.email, password: details.password) { result, error in
                    if let err = error {
                        promise(.failure(err))
                    } else {
                        if let uid = result?.user.uid {
                            self.storeProfilePic(of: uid, details, with: profilePicure)
                        } else {
                            promise(.failure(NSError(domain: "Invalid User Id", code: 0, userInfo: nil)))
                        }
                    }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
//        Auth.auth().createUser(withEmail: details.email, password: details.password) { [weak self] results, error in
//            if let err = error {
//                print(err)
//            } else {
//                if let uid = results?.user.uid {
//                    print("Successfully created user: \(uid)")
//                    self?.storeProfilePic(of: uid, details, with: profilePicure)
//                } else {
//                    print("Invalis User ID")
//                }
//            }
//        }
    }
    
    func storeUsers(_ uid: String, _ details: RegistrationDetails, _ profilePic: String) {
        let userData = ["uid": uid,
                        RegistrationKeys.username.rawValue: details.username,
                        RegistrationKeys.email.rawValue: details.email,
                        RegistrationKeys.profilePicUrl.rawValue: profilePic,
                        RegistrationKeys.totalScore.rawValue: 0
                        ] as [String : Any]
        //"friends": [["id":"", "username":""], ["id":"", "username":""]]
        FirebaseReference(.users).document(uid).setData(userData) { error in
                if let err = error {
                    print(err)
                    return
                }
            }
        print("User details saved!")
    }
    
    func storeProfilePic(of uid: String, _ details: RegistrationDetails, with image: UIImage) {
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
