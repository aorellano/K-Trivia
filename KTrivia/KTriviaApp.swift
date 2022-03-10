//
//  KTriviaApp.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/8/22.
//

import SwiftUI
import Firebase

@main
struct KTriviaApp: App {
    var body: some Scene {
        WindowGroup {
            CategoryListView(viewModel: CategoryListViewModel())
        }
    }
}
