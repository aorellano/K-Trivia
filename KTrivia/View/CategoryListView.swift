//
//  CategoryListView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/8/22.
//

import SwiftUI

struct CategoryListView: View {
    @StateObject var viewModel: CategoryListViewModel
    
    init(viewModel: CategoryListViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
            ForEach(viewModel.groups, id: \.self) { group in
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .frame(height: 80)

                    .shadow(radius: 8)
                    .overlay(
                        Text(group)
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                    )
                    .padding(EdgeInsets(top: 5, leading: -10, bottom: 0, trailing: -10))
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(Visibility.hidden)
        }
        .onAppear(perform: viewModel.getGroups)
    }
}
    
struct CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        let group = "Blackpink"
        let viewModel = CategoryListViewModel()
        viewModel.groups = [group]
        
        return CategoryListView(viewModel: viewModel)
    }
}
