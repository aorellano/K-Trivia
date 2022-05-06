//
//  HomeView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 5/4/22.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var dataService: DataServiceImpl
    @StateObject var viewModel: HomeListViewModel
    @State var isActive: Bool = false
    var user = Auth.auth().currentUser?.uid
    
    init(viewModel:HomeListViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderView(text: "Welcome!")
                    .environmentObject(sessionService)
                    .padding(.trailing, -10)
                Spacer()
                Image(uiImage: UIImage(named: "LaunchScreenIcon")!)
                    .resizable()
                .frame(width: 80, height: 120)
                Spacer()
                NavigationLink(destination: CategoryListView().environmentObject(sessionService), isActive: $isActive){
//                    if selectedCategory != nil {
//                        buttonColor = Color.secondaryColor
//                    }
                    ButtonView(title: "New Game", background: Color.secondaryColor) {
                        isActive = true
                    }
                    .padding()
                }.isDetailLink(false)
                HStack {
                    Text("Current Games")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding()
                    Spacer()
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.games, id: \.id) { game in
                            CurrentGameView(viewModel: viewModel, game: game, sessionService: sessionService)
                                
                        }
                    }
                }
                .onAppear {
                    print(user!)
                    viewModel.getGames(for: user!)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primaryColor)
            .navigationBarHidden(true)
        }
        .environment(\.rootPresentationMode, self.$isActive)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

