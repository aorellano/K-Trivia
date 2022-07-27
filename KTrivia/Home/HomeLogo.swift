//
//  HomeLogo.swift
//  KTrivia
//
//  Created by Alexis Orellano on 5/10/22.
//

import SwiftUI

struct HomeLogo: View {
    var body: some View {
            ZStack {
                Circle()
                    .frame(width: 225, height: 225)
                    .foregroundColor(Color.secondaryColor)
                VStack {
                    Image(uiImage: UIImage(named: "RJ")!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(20))
                        .padding(.leading, 100)
                        .padding(.top, -150)
                    Image(uiImage: UIImage(named: "LaunchScreenIcon")!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .padding(.trailing, 5)
                }
            }
        }
}

struct HomeLogo_Previews: PreviewProvider {
    static var previews: some View {
        HomeLogo()
    }
}
