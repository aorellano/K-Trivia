//
//  CategoryViewModel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/8/22.
//

import FirebaseFirestore

final class CategoryListViewModel: ObservableObject {
    @Published var groups = [String]()
    
    init() {
        fetchGroups()
    }
    
    private func fetchGroups() {
        FirebaseManager.shared.fireStore.collection("questions").addSnapshotListener { (querySnapshot, error) in
            let documents = self.getDocuments(with: querySnapshot)
            self.fetchQuestions(with: documents)
        }
    }
    
    func getDocuments(with querySnapshot: QuerySnapshot?) -> [DocumentSnapshot] {
        if let documents = querySnapshot?.documents {
            return documents
        } else {
            return []
        }
    }
    
    func fetchQuestions(with documents: [DocumentSnapshot]) {
        self.groups = documents.map { (queryDocumentSnapshot) -> String in
            let data = queryDocumentSnapshot.data()
            let category = data?["category"] as? String ?? ""
            return category
        }.removeDuplicates() 
    }
}
