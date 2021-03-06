//
//  LyricsView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/19/22.
//

import SwiftUI

//struct LyricsView: View {
//    @StateObject var viewModel: TriviaViewModel
//    @State var group: String
//    @State var selectedCategory: String
//    @State var answer = ""
//    @State var shouldNavigate = false
//    
//    init(groupName: String, selectedCategory: String, viewModel: TriviaViewModel) {
//        self.group = groupName
//        self.selectedCategory = selectedCategory
//        _viewModel = StateObject(wrappedValue: viewModel)
//    }
//    
//    var body: some View {
//        VStack(spacing: 40) {
//            HStack {
//                Title(text: group, size: 20)
//                Spacer()
//                Title(text: "\(viewModel.timeRemaining)", size: 20)
//            }
//            .padding([.leading, .trailing, .top], 20)
// 
//                Text(viewModel.question?.question ?? "")
//                    .foregroundColor(.white)
//                    .font(.system(size: 22))
//                    .fontWeight(.bold)
//                    .padding()
//            
//      
//            Spacer()
//            InputTextFieldView(text: $answer, placeholder: "Enter Answer", keyboardType: .default, sfSymbol: "")
//                .padding()
//                
//        }
//        
//        .onReceive(viewModel.timer) { time in
//            if viewModel.timeRemaining > 0 {
//                viewModel.timeRemaining -= 1
//            }
//            if viewModel.timeRemaining == 0  {
//                viewModel.endGame()
//                self.shouldNavigate = true
//            }
//        }
//        .onAppear {
//            viewModel.getTheGame()
//        }
//        .onDisappear {
//            viewModel.endGame()
//        }
//        .padding()
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.primaryColor)
//        .navigationBarHidden(true)
//    }
//}
