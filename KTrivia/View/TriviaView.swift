//
//  TriviaView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/10/22.
//

import SwiftUI

struct TriviaView: View {
    var groupName: String
    
    init(groupName: String) {
        self.groupName = groupName
    }
    var body: some View {
        Text(groupName)
    }
}

struct TriviaView_Previews: PreviewProvider {
    static var previews: some View {
        TriviaView(groupName: "BTS")
    }
}
