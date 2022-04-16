//
//  CategoryHeaderView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/8/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct CategoryHeaderView: View {
    @State private var isActive: Bool = false
    @EnvironmentObject var sessionService: SessionServiceImpl
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                ZStack {
                    NavigationLink(destination: SignoutScreen()
                                    .environmentObject(sessionService), isActive: $isActive)
                     {
                         EmptyView()
                     }.isDetailLink(false)
                    WebImage(url: URL(string: sessionService.userDetails?.profilePic ?? ""))
                    //.clipShape(Circle())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipped()
                    .cornerRadius(55)
                
//                    .overlay {
//                        Circle().stroke(.white, lineWidth: 1.5)
//                    }
                    //.shadow(radius: 7)
                    .padding(.trailing, 15)
                    .onTapGesture {
                        isActive = true
                    }
                }
                
                
            }
            Title(text: "Choose Group", size: 30)
            
        }
    }
}

struct CategoryHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHeaderView()
            //.environmentObject(SessionServiceImpl())
    }
}

//NavigationLink(destination: TriviaView(groupName: selectedGroup ?? "", viewModel: TriviaViewModel(groupName: selectedGroup ?? "")), isActive: $isActive) {
//        EmptyView()
//
//}.isDetailLink(false)

//NavigationLink(destination: ResultsView(viewModel: viewModel), isActive: $isActive)
// {
//     EmptyView()
// }.isDetailLink(false)

