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
                
                if viewModel.games.count != 0 {
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
                                //Text(game.blockPlayerId)
                                ZStack {
                                CurrentGameView(viewModel: viewModel, game: game, blockedId: game.blockPlayerId, sessionService: sessionService)
                                    VStack {
                                        if game.player1["id"] == Auth.auth().currentUser?.uid {
                                            if game.player2["username"] == "" {
                                                Text("Waiting...")
                                                    .font(.system(size: 14))
                                                    .fontWeight(.bold)
                                                ProfilePictureView(profilePic: game.player2["profile_pic"], size: 50, cornerRadius: 25)
                                                    
                                            } else {
                                                Text(game.player2["username"] ?? "")
                                                    .font(.system(size: 14))
                                                    .fontWeight(.bold)
                                                ProfilePictureView(profilePic: game.player2["profile_pic"], size: 50, cornerRadius: 25)
                                                
                                          }
                                                
                                        } else {
                                            Text(game.player1["username"] ?? "")
                                                .font(.system(size: 14))
                                                .fontWeight(.bold)
                                            ProfilePictureView(profilePic: game.player1["profile_pic"], size: 50, cornerRadius: 25)
                                            
                                        }
                                            
                                            
                                        HStack {
                                            if game.player1Score == "" && game.player2Score == "" {
                                                Text("0")
                                                    .fontWeight(.bold)
                                                Text("-")
                                                    .fontWeight(.bold)
                                                Text("0")
                                                    .fontWeight(.bold)
                                            } else {
                                                Text(game.player1TotalScore)
                                                    .fontWeight(.bold)
                                                Text("-")
                                                    .fontWeight(.bold)
                                                Text(game.player2TotalScore)
                                                    .fontWeight(.bold)
                          
                                            }
                                        }
                                       
                                        //if checkIfUserIsBlocked() {
                                        if game.blockPlayerId == Auth.auth().currentUser?.uid {
                                            Text("Waiting...")
                                        } else if game.player1TotalScore == "3" || game.player2TotalScore == "3" {
                                            Text("View Results")
                                        } else {
                                            Text("Your Turn!")
                                        }
                                    }
                                    .foregroundColor(.white)
                                }
                                    
                            }
                        }
                    }
                }
            }
                .onAppear {
                    print(user!)
                    viewModel.getGames(for: user!)
                    
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

