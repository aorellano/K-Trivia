//
//  CategoryListView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/8/22.
//

import SwiftUI

struct CategoryListView: View {
    @StateObject var viewModel: CategoryViewModel
    
    init(viewModel: CategoryViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List(viewModel.groups, id: \.self) { group in
            Text(group)
        }
        .onAppear(perform: viewModel.getGroups)
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CategoryViewModel()
        viewModel.groups = ["Blackpink", "BTS", "Twice", "Stray Kids"]
        return CategoryListView(viewModel: viewModel)
    }
}
