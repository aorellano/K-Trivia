//
//  MockDataService.swift
//  KTriviaTests
//
//  Created by Alexis Orellano on 3/11/22.
//

import Foundation

@testable import KTrivia

final class MockDataService: DataService {
    func getQuestions(for group: String, completion: @escaping ([Trivia]) -> Void) {
        <#code#>
    }
    
    var groups: [String] = [""]
    func getGroups(completion: @escaping ([String]) -> Void) {
        completion(
            groups
        )
    }
}
