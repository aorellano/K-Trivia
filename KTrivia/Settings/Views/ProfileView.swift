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

                    Text(sessionService.userDetails?.username ?? "")
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    
                    List {
                       // first section
                       Section(header: Text("Account")) {
                           NavigationLink(destination: NavigationLazyView(FriendsView()).environmentObject(dataService), label: {
                              Text("Friends")
                           })
                        NavigationLink(destination: NavigationLazyView(LeaderboardView()), label: {
                              Text("Leaderboard")
                           })
                       }

                       // second section
                       Section(header: Text("Question Factory")) {
                           NavigationLink(destination: NavigationLazyView(QuestionFactoryView()), label: {
                               Text("Submit Questions")
                            })
                                  
//                           NavigationLink(destination: EmptyView(), label: {
//                                Text("Review Questions")
//                            })
        
                       }
                        
                        
       
                    }
                    .cornerRadius(20)
                    
                    
                    ButtonView(title: "Sign Out", background: Color.secondaryColor) {
                            sessionService.logout()
                    }
                    .padding([.top, .bottom], 20)
                    .navigationTitle(Text("Profile"))
                }
            
                   
                    
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//                    VStack(spacing: 15){
//
//
//
//
////                    SGNavigationLink(destination: LeaderboardView()) {
////                        ZStack {
////                            RoundedRectangle(cornerRadius: 10)
////                                .foregroundColor(.white)
////                                .frame(height: 70)
////                            Text("Past Games")
////                        }
////                    }
//                    SGNavigationLink(destination: FriendsView().environmentObject(sessionService)) {
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 10)
//                                .foregroundColor(.white)
//                                .frame(height: 70)
//                            Text("Friends")
//                        }
//                    }
//                    SGNavigationLink(destination: LeaderboardView()) {
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 10)
//                                .foregroundColor(.white)
//                                .frame(height: 70)
//                            Text("Leaderboard")
//                        }
//                    }
//                    SGNavigationLink(destination: SubmitQuestionView().environmentObject(dataService)) {
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 10)
//                                .foregroundColor(.white)
//                                .frame(height: 70)
//                            Text("Question Factory")
//                        }
//                    }
//                    }
//                    .padding()
//
//                }
//                Spacer()

//
                
                .padding()
                .tint(.black)
                .foregroundColor(.black)
        }
        .onAppear {
       
        }
    }
//    func navigate(to view: String) {
//
//    }
        
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

