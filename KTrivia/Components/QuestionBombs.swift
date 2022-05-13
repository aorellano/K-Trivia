//
//  QuestionBombs.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/21/22.
//

import SwiftUI

struct QuestionBombs: View {
    var totalScore: Int
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 125, height: 35)
                .foregroundColor(Color.secondaryColor)
            HStack {
                ForEach(0..<totalScore, id: \.self) { _ in
                    Image(uiImage: UIImage(named: "LaunchScreenIcon")!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 15, height: 15)
                }
            }
        }

    }
}

struct QuestionBombs_Previews: PreviewProvider {
    static var previews: some View {
        QuestionBombs(totalScore: 3)
    }
}
