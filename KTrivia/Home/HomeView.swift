//
//  HomeView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 5/4/22.
//

import SwiftUI
import FirebaseAuth
import UserNotifications

struct HomeView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var dataService: DataServiceImpl
    @EnvironmentObject var viewModel: HomeListViewModel

    @State var isActive: Bool = false
    var user = Auth.auth().currentUser?.uid
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    HeaderView(text: "")
                        .environmentObject(sessionService)
                        .environmentObject(dataService)
                }
                HStack {
                    WelcomeHeader()
                    .environmentObject(sessionService)
                    .environmentObject(dataService)
                    Spacer()
                }
                .padding(.bottom, 50)
                Spacer()
                HomeLogo()
                Spacer()
                HStack {
                    Text("Current Games:")
                    .foregroundColor(.black)
                        .fontWeight(.bold)
                    Spacer()
                    
                }
                if sessionService.userDetails?.games.count ?? 0 <= 1 {
                    Text("You currently have no games")
                        .font(.system(size:12))
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.games, id: \.id) { game in
                                //Text(game.blockPlayerId)
                                ZStack {
                                    CurrentGameView(viewModel: viewModel, game: game, blockedId: game.blockPlayerId, sessionService: sessionService, winnerId: game.winnerId)
                                    VStack {
                                        if game.player1["id"] == Auth.auth().currentUser?.uid {
                                            if game.player2["username"] == "" {
                                                Text("Waiting...")
                                                    .font(.system(size: 14))
                                                    .fontWeight(.bold)
                                                ProfilePictureView(profilePic: game.player2["profile_pic"], size: 80, cornerRadius: 40)
                                                    
                                            } else {
                                                Text(game.player2["username"] ?? "")
                                                    .font(.system(size: 14))
                                                    .fontWeight(.bold)
                                                ProfilePictureView(profilePic: game.player2["profile_pic"], size: 80, cornerRadius: 40)
                                                
                                          }
                                                
                                        } else {
                                            Text(game.player1["username"] ?? "")
                                                .font(.system(size: 14))
                                                .fontWeight(.bold)
                                            ProfilePictureView(profilePic: game.player1["profile_pic"], size: 80, cornerRadius: 40)
                                            
                                        }
                                            
                                        Text(game.groupName)
                                            .font(.system(size: 13))
                                            .fontWeight(.bold)
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
                                        
                                        if game.winnerId != ""  {
                                            Text("View Results")
                                                .font(.system(size: 14))
                                                .fontWeight(.bold)
                                        } else if game.blockPlayerId == Auth.auth().currentUser?.uid {
                                            Text("Waiting...")
                                                .font(.system(size: 14))
                                                .fontWeight(.bold)
                                        } else {
                                            Text("Your Turn!")
                                                .font(.system(size: 14))
                                                .fontWeight(.bold)
                                           
                                        }
                                    }
                                    .foregroundColor(.white)
                                }
                                    
                            }
                        }
                    }
                }
                Spacer()
                NavigationLink(destination: NavigationLazyView(GameOption()).environmentObject(sessionService), isActive: $isActive){
//                    if selectedCategory != nil {
//                        buttonColor = Color.secondaryColor
//                    }
                   // Spacer()
                    ButtonView(title: "New Game", background: Color.secondaryColor) {
                        isActive = true
                    }
                }.isDetailLink(false)
                
//                if viewModel.games.count != 0 {
//                    HStack {
//                        Text("Current Games")
//                            .foregroundColor(.white)
//                            .fontWeight(.bold)
//                            .padding()
//                        Spacer()
//                    }
//
//
//                }
            }
                .onAppear {
                    print(user!)
                    viewModel.getGames(for: user!)
                    
                }
            
                .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarHidden(true)
            
        }
        
        .environment(\.rootPresentationMode, self.$isActive)
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}

