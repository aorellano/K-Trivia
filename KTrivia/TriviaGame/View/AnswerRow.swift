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
    //@State private var newInt: Int

    

    var answer: Answer
    
    init(answer: Answer, timeRemaining: Int, viewModel: TriviaViewModel ) {
        self.answer = answer
        //self.timeRemaining = timeRemaining
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            NavigationLink(destination: ResultsView(viewModel: viewModel), isActive: $isActive)
             {
                 EmptyView()
             }.isDetailLink(false)
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
//                if viewModel.reachedEnd {
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                        isActive = true
//                    }
//                }
                if !viewModel.answerSelected {
                    isSelected = true
                    viewModel.selectAnswer(answer: answer)
                    backgroundColor = Color.white
                    viewModel.endGame()
                }
                if answer.isCorrect {
                    backgroundColor = .green
                    hapticFeedbackResponse(style: .light)
                } else {
                    backgroundColor = Color.incorrectColor
                    hapticFeedbackResponse(style: .heavy)
                }
    
                isSelected = true
                print(isSelected)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                    self.presentationMode.wrappedValue.dismiss()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isSelected = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                    viewModel.goToNextQuestion()
                }
                
            }
        }.onReceive(viewModel.timer) { time in
            if timeRemaining > 0 {
                timeRemaining -= 1
                print(timeRemaining)

            }
            if timeRemaining == 0 {
                viewModel.endGame()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                    self.presentationMode.wrappedValue.dismiss()
                }
                
                viewModel.timer.upstream.connect().cancel()
 
            }
        }

    }
    func hapticFeedbackResponse(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactMed = UIImpactFeedbackGenerator(style: style)
        impactMed.impactOccurred()
    }
}


