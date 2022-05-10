//
//  SignoutScreen.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/9/22.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var dataService: DataServiceImpl
    @State var isActive: Bool = false
    var body: some View {
        VStack(spacing: 20) {
                VStack {
                ProfilePictureView(profilePic: sessionService.userDetails?.profilePic, size: 100, cornerRadius: 50)
                        .padding(.top, -40)
                    Text(sessionService.userDetails?.username ?? "")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.bottom, 60)
                    VStack(spacing: 15){
//                    SGNavigationLink(destination: LeaderboardView()) {
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 10)
//                                .foregroundColor(.white)
//                                .frame(height: 70)
//                            Text("Past Games")
//                        }
//                    }
                    SGNavigationLink(destination: LeaderboardView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                                .frame(height: 70)
                            Text("Friends")
                        }
                    }
                    SGNavigationLink(destination: LeaderboardView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                                .frame(height: 70)
                            Text("Leaderboard")
                        }
                    }
                    SGNavigationLink(destination: SubmitQuestionView().environmentObject(dataService)) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                                .frame(height: 70)
                            Text("Question Factory")
                        }
                    }
                    }
                    .padding()
                    
                }
                Spacer()
                    ButtonView(title: "Sign Out", background: Color.secondaryColor) {
                        sessionService.logout()
                    }
                    
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .tint(.black)
            
            
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

struct SGNavigationLink<Content, Destination>: View where Destination: View, Content: View {
    let destination:Destination?
    let content: () -> Content


    @State private var isLinkActive:Bool = false

    init(destination: Destination, title: String = "", @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.destination = destination
    }

    var body: some View {
        return ZStack (alignment: .leading){
            if self.isLinkActive{
                NavigationLink(destination: destination, isActive: $isLinkActive){Color.clear}.frame(height:0)
            }
            content()
        }
        .onTapGesture {
            self.pushHiddenNavLink()
        }
    }

    func pushHiddenNavLink(){
        self.isLinkActive = true
    }
}

