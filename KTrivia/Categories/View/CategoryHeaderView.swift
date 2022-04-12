//
//  CategoryHeaderView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/8/22.
//

import SwiftUI

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
                Image(systemName: "person.circle")
                    //.clipShape(Circle())
                    .font(.system(size: 30))
//                    .overlay {
//                        Circle().stroke(.black, lineWidth: 4)
//                    }
                    .shadow(radius: 7)
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

