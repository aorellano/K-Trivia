//
//  LoginService.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/9/22.
//

import Combine
import Foundation
import FirebaseAuth

protocol LoginService {
    func login(with credentials: LoginCredentials) -> Bool
}

final class LoginServiceImpl: LoginService {
    func login(with credentials: LoginCredentials) -> Bool {
        var isSuccessful = false
        Auth.auth().signIn(withEmail: credentials.email, password: credentials.password) { results, error in
            if let err = error {
                print(err)
            } else {
                print("successfully logged in")
                isSuccessful = true
            }
        }
        return isSuccessful
    }
}
