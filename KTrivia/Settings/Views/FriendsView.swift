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
    @EnvironmentObject var dataService: DataServiceImpl
    @Environment(\.dismissSearch) var dismissSearch
    @State var image = "plus.circle.fill"
    @State var showAlert = false
    @State var isActive = false
    var arr = ["Mina", "Momo", "Sana"]
    
    var body: some View {
        ZStack {
        VStack {
        ScrollView {
            if query == "" {
                ForEach(viewModel.friends.indices, id: \.self){ index in
                    HStack {
                       //ProfilePictureView(profilePic: user.profilePic, size: 50, cornerRadius: 25)
                        let friend = viewModel.friends[index]
                        Text(friend["username"] ?? "Can't Find Name")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()

                .accentColor(Color.black)
                .frame(height: 80)
                .background(Color.secondaryColor)
                .cornerRadius(20)
                .shadow(radius: 5, x: 2, y: 2)
                .padding([.leading, .trailing], 20)
                }
            } else {
                ForEach(viewModel.filteredUsers, id: \.id) { user in
                    HStack {
                       //ProfilePictureView(profilePic: user.profilePic, size: 50, cornerRadius: 25)
                        Text(user.username)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        Spacer()
                        if viewModel.friends.contains(["id": user.id, "username": user.username]) {
                            Image(systemName: "")
                        } else {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .foregroundColor(Color.white)
                                .frame(width: 25, height: 25)
                                .onTapGesture {
                                    let yourself = ["id": Auth.auth().currentUser!.uid, "username": sessionService.userDetails?.username ?? ""]
                                    let friend = ["id": user.id , "username": user.username]
                                    viewModel.addFriend(to: yourself, with: friend)
                                    viewModel.getFriends()
                                    query = ""
                                    hideKeyboard()
                                    showAlert = true
                                    dismissSearch()
                                }
                        }
                            
                    }
                    .padding()

                .accentColor(Color.black)
                .frame(height: 60)
                .background(Color.secondaryColor)
                .cornerRadius(15)
                .shadow(radius: 5, x: 2, y: 2)
                .padding([.leading, .trailing], 20)

                }
            }

            }
        }
        .alert("Friend has been added!", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                }

        
        }.onAppear {
           viewModel.getFriends()
        }
        .padding(.top, 50)
        .searchable(text: $query, prompt: "Search for Friend")
        .textInputAutocapitalization(.never)
        .onChange(of: query) { newQuery in
            viewModel.search(with: newQuery)
        }
        .navigationBarTitle("Friends")
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    


struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
