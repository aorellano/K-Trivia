//
//  ResultView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/12/22.
//

import SwiftUI

struct ResultsView: View {
    @StateObject var viewModel: TriviaViewModel
    @Binding var rootIsActive: Bool
    
    init(viewModel: TriviaViewModel, rootIsActive: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self._rootIsActive = rootIsActive
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 100) {
                Title(text: "Your total score is...", size: 30)
                Title(text: viewModel.score.description, size: 60)
                
                Button(action: {self.rootIsActive = false}) {
                    Text("Play again")
                }

                .frame(height: 80)
                .shadow(radius: 5, x: 2, y: 2)
                .frame(width: 200)
                .background(.white)
                .cornerRadius(40)
                
            }
            
        }
        .navigationBarHidden(true)
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        let group = "Blackpink"
        let viewModel = TriviaViewModel(groupName: group)
        
        
        return ResultsView(viewModel: viewModel, rootIsActive: .constant(true))
    }
}
