//
//  ResultView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/12/22.
//

import SwiftUI

struct ResultsView: View {
    @StateObject var viewModel: TriviaViewModel
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.rootPresentationMode) private var rootPresentationMode: Binding<RootPresentationMode>
    
    init(viewModel: TriviaViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 100) {
                Title(text: "Your total score is...", size: 30)
                Title(text: viewModel.score.description, size: 60)
                Title(text: viewModel.results ?? "", size: 30)
                
                Button (action: { self.rootPresentationMode.wrappedValue.dismiss() } )
                            { Text("Play again") }

                .frame(height: 80)
                .shadow(radius: 5, x: 2, y: 2)
                .frame(width: 200)
                .background(.white)
                .cornerRadius(40)
                
                Button (action: { self.rootPresentationMode.wrappedValue.dismiss() } )
                            { Text("Sign Out") }
                
            }
            
        }
        .navigationBarHidden(true)
    }
}

