//
//  AppDataService.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/8/22.
//

import Foundation

protocol DataService {
    func getGroups(completion: @escaping ([String]) -> Void)
}

class AppDataService: DataService {
    func getGroups(completion: @escaping([String]) -> Void) {
        completion([
            "Blackpink",
            "BTS",
            "Twice",
            "Stray Kids"
        ])
    }
}
