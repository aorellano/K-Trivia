//
//  AnswerRow.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/12/22.
//

import SwiftUI

struct AnswerRow: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.rootPresentationMode) private var rootPresentationMode: Binding<RootPresentationMode>
    @StateObject var viewModel: TriviaViewModel
    @State private var backgroundColor = Color.white
    @State private var isSelected = false
    @State private var isActive: Bool = false
    @State private var timeRemaining = 15
    var answer: Answer
    
    init(answer: Answer, timeRemaining: Int, viewModel: TriviaViewModel ) {
        self.answer = answer
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            HStack(spacing: 20) {
                Text(answer.text)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(Color.black)
            .background(backgroundColor)
            .cornerRadius(10)
            .shadow(radius: 4, x: 0.5, y: 0.5)
            .scaleEffect(isSelected ? 0.96 : 1)
            .animation(.spring(response: 0.9, dampingFraction: 0.8), value: 0.6)
            .onTapGesture {
                if !viewModel.answerSelected {
                    isSelected = true
                    viewModel.selectAnswer(answer: answer)
                    backgroundColor = Color.white
                    //viewModel.endGame()
                }
                if answer.isCorrect {
                    backgroundColor = .green
                    hapticFeedbackResponse(style: .light)
                } else {
                    backgroundColor = Color.incorrectColor
                    hapticFeedbackResponse(style: .heavy)
                }
                
                if viewModel.game?.player1TotalScore == "3" || viewModel.game?.player2TotalScore == "3" {
                    viewModel.endGame()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    isSelected = true
                 
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isSelected = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                        viewModel.setQuestion()
                    }
                }
            }
        }.onReceive(viewModel.timer) { time in
            if timeRemaining > 0 {
                timeRemaining -= 1
                print(timeRemaining)
            }
            if timeRemaining == 0 {
                viewModel.selectAnswer(answer: answer)
                viewModel.endGame()
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                    self.presentationMode.wrappedValue.dismiss()
                }
                viewModel.timer.upstream.connect().cancel()
            }
        }
        .onDisappear {
            viewModel.timer.upstream.connect().cancel()
        }
    }
    func hapticFeedbackResponse(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactMed = UIImpactFeedbackGenerator(style: style)
        impactMed.impactOccurred()
    }
}


