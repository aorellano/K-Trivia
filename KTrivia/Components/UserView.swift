//
//  UserView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 7/24/22.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    var viewModel: UsersViewModel
    var isFriend: Bool
    
    init(viewModel: UsersViewModel, isFriend: Bool) {
        self.viewModel = viewModel
        self.isFriend = isFriend
    }
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.users, id: \.id) { user in
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .foregroundColor(Color.secondaryColor)
                        .frame(height: 80)
                    
                            
//                    NavigationLink(destination: NavigationLazyView(SpinWheelView(viewModel: TriviaViewModel(game: game, sessionService: sessionService)))){
                    
                    HStack {
                        if !isFriend {
                            ProfilePictureView(profilePic: user.profilePic, size: 50, cornerRadius: 25)
                         
                            Text(user.username)
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .foregroundColor(Color.white)
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    print("adding as friend")
                                    viewModel.addFriend(to: sessionService.userDetails!, with: user)
                                }
                            
                        }
                        
                        
                    }
                    .padding()
                }
            }
            .padding()
        }
    }

    
}


