//
//  KTriviaApp.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/8/22.
//

import SwiftUI
import Firebase
import gRPC_Core
import SceneKit

@main
struct KTriviaApp: App {
    @StateObject var sessionService = SessionServiceImpl()
    @StateObject var dataService = DataServiceImpl()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            switch sessionService.state {
            case .loggedIn:
                HomeView()
                    .environmentObject(sessionService)
                    .environmentObject(dataService)
                //print(sessionService.userDetails)
            case .loggedOut:
                LoginView()
            }
                
        }
    }
    
    
}
