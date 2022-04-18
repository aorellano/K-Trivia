//
//  CategoryListView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/8/22.
//

import SwiftUI

struct CategoryListView: View {
    @StateObject var viewModel: CategoryListViewModel
    @State var selectedCategory: String? = nil
    @State var isActive: Bool = false
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    init(viewModel: CategoryListViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    CategoryHeaderView()
                        .environmentObject(sessionService)
                        .padding(.top, -50)
                        .padding(.bottom, 20)
                    ScrollView {
                        VStack(spacing: 20) {
                            if selectedCategory != nil {
                                NavigationLink(destination: TriviaView(groupName: selectedCategory ?? "", viewModel: TriviaViewModel(groupName: selectedCategory ?? "", session: sessionService)), isActive: $isActive) {
                                        EmptyView()
                                }.isDetailLink(false)
                            }
                            ForEach(viewModel.groups, id: \.self) { group in
                                Button(action: {
                                    hapticFeedbackResponse()
                                    self.selectedCategory = group
                                    self.isActive = true
                                }) {
                                    HStack {
                                        Spacer()
                                        Text(group)
                                            .fontWeight(.medium)
                                        Spacer()
                                    }
                                }
                                .accentColor(Color.black)
                                .frame(height: 80)
                                .background(.white)
                                .cornerRadius(15)
                                .shadow(radius: 5, x: 2, y: 2)
                                .padding([.leading, .trailing], 20)
                            }
                        }
                    }.onAppear {
                        viewModel.getGroups()
                        UITableView.appearance().backgroundColor = .clear
                        UITableView.appearance().showsVerticalScrollIndicator = false
                    }
                    .padding(.top, 40)
                }
                .padding(.top, 50)
            }
            .navigationBarHidden(true)
            .background(Color.primaryColor)
        }
        .environment(\.rootPresentationMode, self.$isActive)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func hapticFeedbackResponse() {
        let impactMed = UIImpactFeedbackGenerator(style: .light)
        impactMed.impactOccurred()
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



