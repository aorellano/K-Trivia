//
//  SignoutScreen.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/9/22.
//

import SwiftUI

struct SignoutScreen: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Username: \(sessionService.userDetails?.username ?? "N/A")")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            ButtonView(title: "Sign Out", background: Color.secondaryColor) {
                sessionService.logout()
            }
        }.onAppear {
            UINavigationBar.appearance().tintColor = .white
        }
        
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryColor)
        
        
    }
    
}

struct SignoutScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignoutScreen()
            .environmentObject(SessionServiceImpl())
    }
}
