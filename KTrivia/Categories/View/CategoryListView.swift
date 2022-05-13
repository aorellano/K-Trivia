//
//  CategoryListView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/8/22.
//

import SwiftUI

struct CategoryListView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.rootPresentationMode) private var rootPresentationMode: Binding<RootPresentationMode>
    @StateObject var viewModel: CategoryListViewModel
    @State var selectedCategory: String? = nil
    @State var isActive: Bool = false
    @EnvironmentObject var sessionService: SessionServiceImpl
    var user: UserInfo
    init(viewModel: CategoryListViewModel = .init(), user: UserInfo) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.user = user
        print(self.user)
    }
    
    var body: some View {
            ZStack {
                VStack {
                   HStack {
                       Title(text: "Choose Group", size: 30)
                           .padding(.leading, 25)
                           .foregroundColor(.black)
                       Spacer()
                   }
                   .padding(.top, -40)
                    ScrollView {
                        VStack(spacing: 20) {
                            if selectedCategory != nil {
//                                NavigationLink(destination: TriviaView(groupName: selectedCategory ?? "", viewModel: TriviaViewModel(groupName: selectedCategory ?? "", session: sessionService)), isActive: $isActive) {
//                                        EmptyView()
//                                }.isDetailLink(false)
                                NavigationLink(destination: NavigationLazyView(SpinWheelView(groupName: selectedCategory ?? "", viewModel: TriviaViewModel(groupName: selectedCategory ?? "", sessionService: sessionService, gameId: "", user: user))), isActive: $isActive) {
                                                                        EmptyView()
                                                                }
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
                                            .foregroundColor(.white)
                                        Spacer()
                                    }
                                }
                                .accentColor(Color.black)
                                .frame(height: 80)
                                .background(Color.secondaryColor)
                                .cornerRadius(15)
                                .shadow(radius: 5, x: 2, y: 2)
                                .padding([.leading, .trailing], 20)
                            }
                        }
                        .padding(.top, 60)
                    }.onAppear {
                        viewModel.getGroups()
//                        UITableView.appearance().backgroundColor = .clear
//                        UITableView.appearance().showsVerticalScrollIndicator = false
                
                    }
                    
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red:242/255, green: 242/255, blue: 247/255))
    
        
//        .environment(\.rootPresentationMode, self.$isActive)
//        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func hapticFeedbackResponse() {
        let impactMed = UIImpactFeedbackGenerator(style: .light)
        impactMed.impactOccurred()
    }
}





