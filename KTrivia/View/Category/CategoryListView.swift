//
//  CategoryListView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/8/22.
//

import SwiftUI

struct CategoryListView: View {
    @StateObject var viewModel: CategoryListViewModel
    @State private var isTapped = false
    @State var selectedGroup: String? = nil
    @State var navigationViewIsActive: Bool = false
    
    init(viewModel: CategoryListViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack {
                    if selectedGroup != nil {
                        NavigationLink(destination:
                                        TriviaView(groupName: selectedGroup ?? "", viewModel: TriviaViewModel(groupName: selectedGroup ?? "")), isActive: $navigationViewIsActive) {
                            EmptyView()
                       
                    }.hidden()
                }
                    
                ForEach(viewModel.groups, id: \.self) { group in
                        Button(action: {
                            let impactMed = UIImpactFeedbackGenerator(style: .light)
                            impactMed.impactOccurred()
                            print("group: \(group)")
                            
                            self.selectedGroup = group
                            self.navigationViewIsActive = true
                        }) {
                            HStack {
                                Spacer()
                                Text(group)
                                Spacer()
                            }
                        }
                        .accentColor(Color.black)
                        .frame(height: 80)
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5, x: 2, y: 2)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    
                }
            }
            
        }.onAppear {
            viewModel.getGroups()
            UITableView.appearance().backgroundColor = .clear
            UITableView.appearance().showsVerticalScrollIndicator = false
        }
        
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

struct DeferView<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }
    var body: some View {
        content()          // << everything is created here
    }
}


}
