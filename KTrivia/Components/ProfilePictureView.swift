//
//  ProfilePictureView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/17/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfilePictureView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    let profilePic: String?
    let size: CGFloat
    let cornerRadius: CGFloat
    
    var body: some View {
        if let pic = profilePic {
            WebImage(url: URL(string: pic))
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .cornerRadius(cornerRadius)
                .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.gray, lineWidth: 1.5))
        } else {
            Image(systemName: "person.crop.circle.badge.plus")
                .font(.system(size: size, weight: .light))
                .foregroundColor(.white)
        }
    
    }
}

struct ProfilePictureView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePictureView(profilePic: "", size: 100, cornerRadius: 100)
    }
}
