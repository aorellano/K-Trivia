//
//  CurrentGameView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 5/4/22.
//

import SwiftUI
import FirebaseAuth

struct CurrentGameView: View {
    @StateObject var viewModel: HomeListViewModel
    @State var game: Game
    @State var isActive: Bool = false
    var sessionService: SessionServiceImpl
    @State var backgroundColor = Color.white
   
    init(viewModel: HomeListViewModel, game: Game, sessionService: SessionServiceImpl) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.game = game
        self.sessionService = sessionService
    }
    
    var body: some View {
        ZStack {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundColor(Color.secondaryColor)
            .frame(width: 100, height: 150)
            .shadow(radius: 4, x: 1, y: 1)
            .onTapGesture {
                print(game)
                print("GROUPNAME \(game.groupName)")
                isActive = true
            }
            //spinWheel should be sent a gameObject and if it is nil then game should be created
            NavigationLink(destination: NavigationLazyView(SpinWheelView(groupName: game.groupName, viewModel: TriviaViewModel(groupName: game.groupName, sessionService: sessionService, gameId: game.id))), isActive: $isActive) {
                
                EmptyView()
            }.isDetailLink(false)
            
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
                        Text(game.player1Score)
                            .fontWeight(.bold)
                        Text("-")
                            .fontWeight(.bold)
                        Text(game.player2Score)
                            .fontWeight(.bold)
  
                    }
                }
               
                if game.blockPlayerId == Auth.auth().currentUser?.uid {
                    Text("Waiting...")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                    
                } else {
                   
                    Text("Your Turn!")
                        .font(.system(size: 14))
                        .fontWeight(.bold)

                }
            }
            
         
        }
        .foregroundColor(.white)
    }
        
}

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

