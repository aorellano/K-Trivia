//
//  HomeView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 5/4/22.
//

import SwiftUI
import FirebaseAuth
import UserNotifications

struct HomeView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    @State var isActive: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    HeaderView(text: "")
                        .environmentObject(sessionService)
                }
                HStack {
                    WelcomeHeader()
                    .environmentObject(sessionService)
                    Spacer()
                }
                Spacer()
                HomeLogo()
                Spacer()
                NavigationLink(destination: NavigationLazyView(CategoryListView(opponent: nil)).environmentObject(sessionService), isActive: $isActive){
                    ButtonView(title: "Quick Game", background: Color.secondaryColor) {
                        isActive = true
                    }
                }.isDetailLink(false)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .navigationBarHidden(true)
        }
        .environment(\.rootPresentationMode, self.$isActive)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

