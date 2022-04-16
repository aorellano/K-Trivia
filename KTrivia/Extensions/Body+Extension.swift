//
//  Body+Extension.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/15/22.
//

import Foundation
import SwiftUI

struct BackgroundColorStyle: ViewModifier {

    func body(content: Content) -> some View {
        return content
            .background(Color(red: 132/255, green: 52/255, blue: 245/255))
      
    }
}
