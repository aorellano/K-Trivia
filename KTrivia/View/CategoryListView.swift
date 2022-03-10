//
//  CategoryListView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/8/22.
//

import SwiftUI

struct CategoryListView: View {
    @ObservedObject var viewModel = CategoryListViewModel()
    var body: some View {
        List {
            ForEach(viewModel.groups, id: \.self) { group in
                Text(group)
            }
        }
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView(viewModel: CategoryListViewModel())
    }
}
