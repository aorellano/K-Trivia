//
//  LoginCredentials.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/9/22.
//

import Foundation

struct LoginCredentials {
    var email: String
    var password: String
}

extension LoginCredentials {
    static var new: LoginCredentials {
        LoginCredentials(email: "", password: "")
    }
}
