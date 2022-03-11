//
//  TitleText.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/10/22.
//

import SwiftUI

struct Title: View {
    var text: String
    var size: Int
    var body: some View {
        Text(text)
            .font(.system(size: 30, weight: .bold, design: .rounded))
            .foregroundColor(.black)
    }
}

