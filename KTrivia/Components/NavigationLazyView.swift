//
//  NavigationLazyView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 7/26/22.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
