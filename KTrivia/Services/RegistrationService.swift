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

protocol RegistrationService {
    func register(with details: RegistrationDetails, and profilePicture: UIImage)
}

final class RegistrationServiceImpl: ObservableObject, RegistrationService {
    func register(with details: RegistrationDetails, and profilePicure: UIImage) {
        Auth.auth().createUser(withEmail: details.email, password: details.password) { [weak self] results, error in
            if let err = error {
                print(err)
            } else {
                if let uid = results?.user.uid {
                    print("Successfully created user: \(uid)")
                    self?.storeProfilePic(of: uid, details, with: profilePicure)
                } else {
                    print("Invalis User ID")
                }
            }
        }
    }
    
    func storeUsers(_ uid: String, _ details: RegistrationDetails, _ profilePic: String) {
        let userData = ["uid": uid, "username": details.username, "email": details.email, "profilePicUrl": profilePic, "games": [""], "totalScore": 0] as [String : Any]
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
