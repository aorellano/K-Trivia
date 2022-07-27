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
    @State var opponent: [String: String]? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                if query == "" {
                    if viewModel.friends.first == ["":""] || viewModel.friends.isEmpty {
                        Text("Swipe up to add Friends")
                            .foregroundColor(Color.black)
                    } else {
                    ForEach(viewModel.friends.indices, id: \.self) { index in
                        let friend = viewModel.friends[index]
                        ZStack {
                            if opponent != nil {
                                NavigationLink(destination: NavigationLazyView(CategoryListView(opponent: friend)), isActive: $isActive) {
                                                                        EmptyView()
                                }.isDetailLink(false)
                            }
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .foregroundColor(Color.secondaryColor)
                                .frame(height: 80)
                                .padding([.leading, .trailing], 15)
                                
                            HStack {
                                ProfilePictureView(profilePic: friend["profile_pic"], size: 50, cornerRadius: 25)
                                    .padding(.leading, 30)
                                Text(friend["username"] ?? "Cant Find Name")
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "play.fill")
                                    .resizable()
                                    .foregroundColor(Color.white)
                                    .frame(width: 25, height: 25)
                                    .padding(.trailing, 30)
                                    .onTapGesture {
                                        print("Starting game with \(friend["username"])")
                                        opponent = friend
                                        isActive = true
                                    }
                                
                            }
                            
                            
                        }
                    }

                    }
                } else {
                    ForEach(viewModel.users, id: \.id) { user in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .foregroundColor(Color.secondaryColor)
                                .frame(height: 80)
                            HStack {
                                ProfilePictureView(profilePic: user.profilePic, size: 50, cornerRadius: 25)
                                Text(user.username)
                                    .foregroundColor(.white)
                                Spacer()
                                let usr = ["id": user.id, "username": user.username, "profile_pic": user.profilePic]
                                if viewModel.friends.contains(where: {$0 == usr }) {
                                    Text("")
                                } else {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .foregroundColor(Color.white)
                                        .frame(width: 24, height: 24)
                                        .onTapGesture {
                                            print("adding as friend")
                                            viewModel.addFriend(to: sessionService.userDetails!, with: user)
                                            viewModel.getFriends(for: sessionService.userDetails!)
                                            query = ""
                                                                                hideKeyboard()
                                                                                showAlert = true
                                                                                dismissSearch()
                                        
                                        }
                                }
                                
                            }.padding()
                        }
                        .padding()
                    }
                }
                    
            }
        
            
//            Text("Searching for \(query)")
                .searchable(text: $query, prompt: "Search for Friend")
                .onSubmit(of: .search) {
                    viewModel.search(for: query)
                    dismissSearch()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .navigationTitle("Friends")
                .alert("Friend has been added!", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                }
            
        }.onAppear {
            viewModel.getFriends(for: sessionService.userDetails!)
        }
        .textInputAutocapitalization(.never)
        .environment(\.rootPresentationMode, self.$isActive)
        .navigationViewStyle(StackNavigationViewStyle())

       
//        ZStack {
//        VStack {
//            Text("Friends")
//        ScrollView {
//            if query == "" {
//                ForEach(viewModel.friends.indices, id: \.self){ index in
//                    HStack {
//                       //ProfilePictureView(profilePic: user.profilePic, size: 50, cornerRadius: 25)
//                        let friend = viewModel.friends[index]
//                        Text(friend["username"] ?? "Can't Find Name")
//                            .fontWeight(.medium)
//
//                        Spacer()
//                    }
//                    .padding()
//
//                .accentColor(Color.black)
//                .frame(height: 80)
//                .background(Color.secondaryColor)
//                .cornerRadius(20)
//                .shadow(radius: 5, x: 2, y: 2)
//                .padding([.leading, .trailing], 20)
//                }
//            } else {
//                ForEach(viewModel.filteredUsers, id: \.id) { user in
//                    HStack {
//                       //ProfilePictureView(profilePic: user.profilePic, size: 50, cornerRadius: 25)
//                        Text(user.username)
//                            .fontWeight(.medium)
//                            .foregroundColor(.white)
//                        Spacer()
//                        if viewModel.friends.contains(["id": user.id, "username": user.username]) {
//                            Image(systemName: "")
//                        } else {
//                            Image(systemName: "plus.circle.fill")
//                                .resizable()
//                                .foregroundColor(Color.white)
//                                .frame(width: 25, height: 25)
//                                .onTapGesture {
//                                    let yourself = ["id": Auth.auth().currentUser!.uid, "username": sessionService.userDetails?.username ?? ""]
//                                    let friend = ["id": user.id , "username": user.username]
//                                    viewModel.addFriend(to: yourself, with: friend)
//                                    viewModel.getFriends()
//                                    query = ""
//                                    hideKeyboard()
//                                    showAlert = true
//                                    dismissSearch()
//                                }
//                        }
//
//                    }
//                    .padding()
//
//                .accentColor(Color.black)
//                .frame(height: 60)
//                .background(Color.secondaryColor)
//                .cornerRadius(15)
//                .shadow(radius: 5, x: 2, y: 2)
//                .padding([.leading, .trailing], 20)
//
//                }
//            }
//
//            }
//        }
//        .alert("Friend has been added!", isPresented: $showAlert) {
//                    Button("OK", role: .cancel) { }
//                }
//
//
//        }.onAppear {
//           viewModel.getFriends()
//        }
//        .padding(.top, 50)
//        .searchable(text: $query, prompt: "Search for Friend")
//        .textInputAutocapitalization(.never)
//        .onChange(of: query) { newQuery in
//            //viewModel.search(with: newQuery)
//        }
//
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(.white)
        
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
