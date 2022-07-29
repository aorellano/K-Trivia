//
//  CategorySerice.swift
//  KTrivia
//
//  Created by Alexis Orellano on 7/26/22.
//

import Foundation

protocol CategoryService {
    func getCategories() async throws -> [String]
}

class CategoryServiceImpl: ObservableObject, CategoryService {
    func getCategories() async throws -> [String] {
        let snapshot = try await FirebaseReference(.questions).getDocuments()
        
        return snapshot.documents.compactMap { document in
            let data = document.data()
            let category = data["category"] as? String ?? ""
            return category
        }.removeDuplicates().filter({$0 != ""})
    }
}
