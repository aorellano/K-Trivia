//
//  FriendsView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 5/9/22.
//

import SwiftUI
import FirebaseAuth

struct FriendsView: View {
    @StateObject var viewModel = UsersViewModel()
    @State private var query = ""
    @EnvironmentObject var sessionService: SessionServiceImpl
    var arr = ["Mina", "Momo", "Sana"]
    
    var body: some View {
        VStack {
        ScrollView {
            if query == "" {
                ForEach(viewModel.friends, id: \.self){ friend in
                    HStack {
                       //ProfilePictureView(profilePic: user.profilePic, size: 50, cornerRadius: 25)
                        Text(friend.values.first ?? "")
                            .fontWeight(.medium)
                        Spacer()
                        Text("Play")
                            .fontWeight(.bold)
                            .onTapGesture {
                                print("going to game")
                            }
                    }
                    .padding()
                
                .accentColor(Color.black)
                .frame(height: 60)
                .background(.white)
                .cornerRadius(15)
                .shadow(radius: 5, x: 2, y: 2)
                .padding([.leading, .trailing], 20)
                }
            } else {
                ForEach(viewModel.filteredUsers, id: \.id) { user in
                    HStack {
                       //ProfilePictureView(profilePic: user.profilePic, size: 50, cornerRadius: 25)
                        Text(user.username)
                            .fontWeight(.medium)
                        Spacer()
                       
                        Text("Add")
                            .fontWeight(.bold)
                            .foregroundColor(Color.primaryColor)
                            .onTapGesture {
                                viewModel.addFriend(to: [Auth.auth().currentUser!.uid: sessionService.userDetails?.username ?? ""], with: [user.id : user.username])
                                print("adding")
                            }
                    }
                    .padding()
                
                .accentColor(Color.black)
                .frame(height: 60)
                .background(.white)
                .cornerRadius(15)
                .shadow(radius: 5, x: 2, y: 2)
                .padding([.leading, .trailing], 20)
            
                }
                
            }
        
                
        }.onAppear {
            viewModel.getFriends()
        }
        .searchable(text: $query, prompt: "Search for Friend")
        .textInputAutocapitalization(.never)
        .onChange(of: query) { newQuery in
            viewModel.search(with: newQuery)
        }
        .navigationBarTitle("Friends")
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryColor)
        }

        
    }
    
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}
