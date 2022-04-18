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
                    NavigationLink(destination: SignoutScreen().environmentObject(sessionService), isActive: $isActive) {
                         EmptyView()
                     }.isDetailLink(false)
                    ProfilePictureView(size: 50, cornerRadius: 50)
                        .environmentObject(sessionService)
                    .padding(.top, 10)
                    .padding(.trailing, 20)
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
            .environmentObject(SessionServiceImpl())
    }
}
