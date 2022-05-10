//
//  LeaderboardView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 5/6/22.
//

import SwiftUI

struct LeaderboardView: View {
   @StateObject var viewModel: LeaderboardViewModel
    var arr = ["first", "second", "third", "fourth", "fifth"]
    
    init(viewModel: LeaderboardViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack {
            Title(text: "Leaderboard", size: 30)
                .padding(.top, -20)
                .padding(.bottom, 60)
            ScrollView {
                ForEach(viewModel.users, id: \.id) { user in
   
                        HStack {
                            ProfilePictureView(profilePic: user.profilePic, size: 50, cornerRadius: 25)
                            Text(user.username)
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(Int(user.totalScore))")
                                .fontWeight(.bold)
                        }
                        .padding()
                    
                    .accentColor(Color.black)
                    .frame(height: 80)
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(radius: 5, x: 2, y: 2)
                    .padding([.leading, .trailing], 20)
                }
            }
        }.onAppear {
            viewModel.getUsers()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryColor)
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
