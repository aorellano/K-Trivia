//
//  CategoryHeaderView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/8/22.
//
import SwiftUI
import SDWebImageSwiftUI

struct HeaderView: View {
    @State private var isActive: Bool = false
    @EnvironmentObject var sessionService: SessionServiceImpl
    @EnvironmentObject var dataService: DataServiceImpl
    @State private var text: String
    
    init(text: String) {
        self.text = text
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                ZStack {
//                    NavigationLink(destination: NavigationLazyView(ProfileView()).environmentObject(sessionService).environmentObject(dataService), isActive: $isActive) {
//                         EmptyView()
//                     }.isDetailLink(false)
                    ProfilePictureView(profilePic: sessionService.userDetails?.profilePic, size: 50, cornerRadius: 50)
                        .environmentObject(sessionService)
               
                    .onTapGesture {
                        isActive = true
                    }
                }
            }
        }
    }
}

struct CategoryHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(text: "Default")
            .environmentObject(SessionServiceImpl())
    }
}
