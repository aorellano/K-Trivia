//
//  KTriviaApp.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/8/22.
//

import SwiftUI
import Firebase
import gRPC_Core

@main
struct KTriviaApp: App {
    @StateObject var sessionService = SessionServiceImpl()
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            switch sessionService.state {
            case .loggedIn:
                CategoryListView()
                    .environmentObject(sessionService)
            case .loggedOut:
                LoginView()
            }
        }
    }
}
