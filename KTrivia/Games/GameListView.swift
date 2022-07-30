//
//  GameListView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 7/13/22.
//

import SwiftUI
import AVFAudio

struct GameListView: View {
    var games: [Game]
    var currentPlayer: String
    @State var isActive = false
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    init(_ games: [Game], _ currentPlayer: String) {
        self.games = games
        self.currentPlayer = currentPlayer
    }
    
    var body: some View {
        ScrollView {
            ForEach(games) { game in
                ZStack {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .foregroundColor(Color.secondaryColor)
                            .frame(height: 100)
                    NavigationLink(destination: NavigationLazyView(SpinWheelView(viewModel: TriviaViewModel(game: game, sessionService: sessionService)))){
                    HStack {
                        if currentPlayer == game.player1["id"] {
                            ProfilePictureView(profilePic: game.player1["profile_pic"], size: 50, cornerRadius: 25)
                            Spacer()
                            VStack {
                                Text(game.groupName)
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                Text("\(game.player1TotalScore) - \(game.player2TotalScore)")
                                    .font(.system(size: 34))
                                    .fontWeight(.bold)
                                if game.winnerId != "" {
                                    Text("Game has Finished")
                                        .font(.system(size: 13))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.gray)
                                } else if game.blockPlayerId != currentPlayer {
                                    Text("Your Turn")
                                        .font(.system(size: 13))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.green)
                                } else {
                                    Text("Waiting for Opponent")
                                        .font(.system(size: 13))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.gray)
                                }
                            }
                            Spacer()
                            ProfilePictureView(profilePic: game.player2["profile_pic"], size: 50, cornerRadius: 25)
                        } else {
                            ProfilePictureView(profilePic: game.player2["profile_pic"], size: 50, cornerRadius: 25)
                            Spacer()
                            VStack {
                                Text(game.groupName)
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                Text("\(game.player2TotalScore) - \(game.player1TotalScore)")
                                    .font(.system(size: 34))
                                    .fontWeight(.bold)
                                if game.winnerId != "" {
                                    Text("Game has Finished")
                                        .font(.system(size: 13))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.gray)
                                } else if game.blockPlayerId != currentPlayer {
                                    Text("Your Turn")
                                        .font(.system(size: 13))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.green)
                                } else {
                                    Text("Waiting for Opponent")
                                        .font(.system(size: 13))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.gray)
                                }
                            }
                            Spacer()
                            ProfilePictureView(profilePic: game.player1["profile_pic"], size: 50, cornerRadius: 25)
                        }
                    }
                   }.isDetailLink(false)
                    .padding([.leading, .trailing], 10)
   
                }
                .padding([.leading, .trailing], 15)
                .foregroundColor(.white)
            }
        }
    }
}
