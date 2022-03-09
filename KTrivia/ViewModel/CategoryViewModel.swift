//
//  CategoryViewModel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/8/22.
//

import Foundation

final class CategoryViewModel: ObservableObject {
    let dataService: DataService
    
    init(dataService: DataService = AppDataService()) {
        self.dataService = dataService
    }
    
    @Published var groups = [String]()
    
    func getGroups() {
        dataService.getGroups { [weak self] groups in
            self?.groups = groups
        }
    }
}
