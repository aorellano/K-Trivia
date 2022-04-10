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
                Text("First Name: \(sessionService.userDetails?.username ?? "N/A")")
            }
            ButtonView(title: "Sign Out") {
                sessionService.logout()
            }
        }
        
    }
}

struct SignoutScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignoutScreen()
            .environmentObject(SessionServiceImpl())
    }
}
