//
//  CategoryViewModel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/8/22.
//

import FirebaseFirestore

class CategoryListViewModel: ObservableObject {
    @Published var groups = [String]()
    var dataService: CategoryDataService
    
    
    init(dataService: CategoryDataService = FirebaseService()) {
        self.dataService = dataService
    }
    
    func getGroups() {
        dataService.getGroups { [weak self] groups in
            self?.groups = groups
        }
    }
}
