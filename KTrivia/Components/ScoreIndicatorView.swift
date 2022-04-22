//
//  ScoreIndicator.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/21/22.
//

import SwiftUI

struct ScoreIndicatorView: View {
    let colors: [Color]
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(colors[0])
                .frame(width: 40, height: 10)
                .cornerRadius(10)
            Rectangle()
                .fill(colors[1])
                .frame(width: 40, height: 10)
                .cornerRadius(10)
            Rectangle()
                .fill(colors[2])
                .frame(width: 40, height: 10)
                .cornerRadius(10)
        }
        
    }
}

struct ScoreIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ScoreIndicatorView(colors: [Color.secondaryColor, .white, .white])
    }
}
