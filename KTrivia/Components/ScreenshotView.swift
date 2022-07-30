//
//  ScreenshotView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/20/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ScreenshotView: View {
    let screenshotImage: String?

    var body: some View {
        if let image = screenshotImage {
            AsyncImage(url: URL(string: image)) { img in
                img.resizable()
                  
            } placeholder: {
                ProgressView()
            }
            .scaledToFill()
           
       
           
                //.resizable()
                
                //.cornerRadius(20)
                //.overlay(RoundedRectangle(cornerRadius: cornerRadius)
                //.stroke(Color.gray, lineWidth: 1.5)
        } else {
            Image(systemName: "photo")
                .font(.system(size: 300, weight: .light))
                .foregroundColor(.white)
                
        }
    }
}

struct ScreenshotView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenshotView(screenshotImage: "")
    }
}
