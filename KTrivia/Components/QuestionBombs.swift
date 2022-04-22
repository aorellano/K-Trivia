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

struct QuestionBombs_Previews: PreviewProvider {
    static var previews: some View {
        QuestionBombs(totalScore: 3)
    }
}
