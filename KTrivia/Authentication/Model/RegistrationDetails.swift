//
//  RegistrationDetails.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/16/22.
//

import Foundation

struct RegistrationDetails {
    var email: String
    var password: String
    var username: String
}

extension RegistrationDetails {
    static var new: RegistrationDetails {
        RegistrationDetails(email: "",
                            password: "",
                            username: "")
    }
}
