//
//  CategoryViewModel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/8/22.
//

import FirebaseFirestore

class CategoryListViewModel: ObservableObject {
    @Published var categories = [String]()
    var service: CategoryService
    
    init(service: CategoryService = CategoryServiceImpl()) {
        self.service = service
    }
    
    @MainActor
    func getGroups() {
        Task.init {
            categories = try await service.getCategories()
        }
    }
}
