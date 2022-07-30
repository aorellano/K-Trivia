//
//  SessionUserDetails.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/17/22.
//

import Foundation

struct SessionUserDetails {
    let id: String
    let username: String
    let profilePic: String
    let totalScore: Double
    let games: [String]?
    let friends: [[String:String]]?
}
