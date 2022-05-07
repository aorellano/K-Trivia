//
//  SignoutScreen.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/9/22.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    @State var isActive: Bool = false
    var body: some View {
        VStack {
//                Title(text: "Profile", size: 30)
//                .padding(.top, -30)
                
            ZStack {
                NavigationLink(destination: LeaderboardView(), isActive: $isActive) {
                    EmptyView()
                }
                VStack {
                    
                
                ProfilePictureView(profilePic: sessionService.userDetails?.profilePic, size: 100, cornerRadius: 50)
                    .padding()
                    Text(sessionService.userDetails?.username ?? "")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                Form {
                    Button("Past Games") {
                        print("going to past games")
                    }
                    Button("Friends") {
                        print("going to friends")
                    }
                    Button("Leaderboard") {
                        print("going to leaderboard")
                        isActive = true
                        //navigate(to: "LeaderboardView")
                    }
                    Button("Question Factory") {
                        print("going to question factory")
                    }
                    Section {
                        Button("Sign Out") {
                            sessionService.logout()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                    
                
                    
                }
                .tint(.black)
            }
                
        }
        .background(Color.primaryColor)
        .onAppear {
            UITableView.appearance().backgroundColor = UIColor(red: 132/255, green: 52/255, blue: 245/255, alpha: 1)
            UINavigationBar.appearance().tintColor = .white
        }
        .preferredColorScheme(.light)
    }
    func navigate(to view: String) {
        
    }
        
}

struct SignoutScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(SessionServiceImpl())
    }
}
