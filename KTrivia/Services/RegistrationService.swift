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

protocol RegistrationService {
    func register(with details: RegistrationDetails) -> AnyPublisher<Void, Error>
}

final class RegistrationServiceImpl: ObservableObject, RegistrationService {
    func register(with details: RegistrationDetails) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                Auth
                    .auth()
                    .createUser(withEmail: details.email, password: details.password) { res, error in
                        print("This is the password\(details.password)")
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            if let uid = res?.user.uid {
                                print("Successfully created user: \(uid)")
                                self.storeUsers(uid, details)
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
    
    func storeUsers(_ uid: String, _ details: RegistrationDetails) {
        let userData = ["uid": uid, "username": details.username, "email": details.email]
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
}
