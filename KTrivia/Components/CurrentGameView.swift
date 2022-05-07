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
    @State var currentStatus: String?
    @State var blockedId: String?
   
    init(viewModel: HomeListViewModel, game: Game, blockedId: String, sessionService: SessionServiceImpl) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.game = game
        self.blockedId = blockedId
        print(blockedId)
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
            if game.player1TotalScore == "3" || game.player2TotalScore == "3" {
                NavigationLink(destination: NavigationLazyView(ResultsView(viewModel: TriviaViewModel(groupName: game.groupName, sessionService: sessionService, gameId: game.id))), isActive: $isActive) {
                        
                        EmptyView()
                    }.isDetailLink(false)
            } else {
                NavigationLink(destination: NavigationLazyView(SpinWheelView(groupName: game.groupName, viewModel: TriviaViewModel(groupName: game.groupName, sessionService: sessionService, gameId: game.id))), isActive: $isActive) {
                        
                        EmptyView()
                    }.isDetailLink(false)
            }
            
         
        }.onAppear {
            
            //checkIfUserIsBlocked()
            print("GAME \(game)")
        }
        
    }
    
//    func checkIfUserIsBlocked()  {
//        print("Blocked user: \(blockedId)")
//        if blockedId == Auth.auth().currentUser?.uid {
//            currentStatus = "Waiting..."
//        } else if game.player1TotalScore == "3" || game.player2TotalScore == "3" {
//            currentStatus = "View Results"
//        } else {
//            currentStatus = "Your Turn!"
//        }
//    }
        
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
