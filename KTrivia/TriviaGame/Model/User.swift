//
//  User.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/11/22.
//

import Foundation

struct User: Codable {
    var uid: String
    var profilePicUrl: String
    var email: String
    var username: String
}
