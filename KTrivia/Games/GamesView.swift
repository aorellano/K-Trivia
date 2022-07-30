//
//  GamesView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 7/13/22.
//

import SwiftUI
import Introspect

struct GamesView: View {
    @StateObject var viewModel: GamesViewModel
    @EnvironmentObject var sessionService: SessionServiceImpl
    @State var isActive: Bool = false
    @State var tabBarController: UITabBarController?
    @State var isLoading: Bool = true
    
    init(viewModel: GamesViewModel = .init()){
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Current Games")
                        .font(.system(size: 26))
                        .fontWeight(.bold)
                        .padding(.leading, 15)
                        .padding(.top, 20)
                    Spacer()
                }
                .padding(.bottom, 20)
                
                if viewModel.isRefreshing {
                    ProgressView()
                } else {
                    if viewModel.games.count == 0 {
                        Text("You currently have no games...")
                            .foregroundColor(.gray)
                        Spacer()
                    } else {
                        GameListView(viewModel.games, sessionService.userDetails?.id ?? "")
                            .environmentObject(sessionService)
                    }
                }
            }.introspectTabBarController { (UITabBarController) in
                UITabBarController.tabBar.isHidden = false
                tabBarController = UITabBarController
            }
            .task {
                let games = sessionService.userDetails?.games ?? [""]
                if games.count != 0 {
                    print("gamesView")
                    await viewModel.fetchGames(with: sessionService.userDetails?.games ?? [""])
                }
            }
//            .onAppear {
//                print("Your games are loading")
//                let games = sessionService.userDetails?.games ?? [""]
//                if games.count != 0 {
//
//                    viewModel.fetchGames(with: sessionService.userDetails?.games ?? [""])
//               }
//
//            }
            .padding(.top, 30)
            .navigationBarHidden(true)
            .foregroundColor(Color.black)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            
        }
        
        .environment(\.rootPresentationMode, self.$isActive)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
