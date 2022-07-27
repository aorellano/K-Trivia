//
//  IncrementError.swift
//  KTrivia
//
//  Created by Alexis Orellano on 7/11/22.
//

import Foundation

enum IncrementError: LocalizedError {
    case auth(description: String)
case `default`(description: String? = nil)
    
    var errorDescription: String? {
        switch self {
        case let .auth(description):
            return description
        case let .default(description):
            return description ?? "Something went wrong"
        }
    }
}
