//
//  LeaderboardView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 5/6/22.
//

import SwiftUI

struct LeaderboardView: View {
   @StateObject var viewModel: UsersViewModel
    var arr = ["first", "second", "third", "fourth", "fifth"]
    
    init(viewModel: UsersViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack {
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
                    
                    //.accentColor(Color.black)
                    .foregroundColor(.white)
                    .frame(height: 80)
                    .background(Color.secondaryColor)
                    .cornerRadius(15)
                    .shadow(radius: 5, x: 2, y: 2)
                    .padding([.leading, .trailing], 20)
                }
                .padding(.top, 60)
            }
        }.onAppear {
            viewModel.getUsers()
        }
        .navigationTitle("Leaderboard")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
