//
//  AnswerRow.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/12/22.
//

import SwiftUI

struct AnswerRow: View {
    @StateObject var viewModel: TriviaViewModel
    @State private var backgroundColor = Color.white
    @State private var isSelected = false
    @State private private var showingSheet = false
    var answer: Answer
   
    
    init(answer: Answer, viewModel: TriviaViewModel) {
        self.answer = answer
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
    var body: some View {
        ZStack {
            
//            NavigationLink(destination: ResultsView(viewModel: viewModel), isActive: $navigationViewIsActive)
//             {
                 
                HStack(spacing: 20) {
                    Text(answer.text)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
//             }.isDetailLink(false)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(Color.black)
            .background(backgroundColor)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 5, x: 0.5, y: 0.5)
            .scaleEffect(isSelected ? 0.96 : 1)
            .animation(.spring(response: 0.9, dampingFraction: 0.8), value: 0.6)
            .onTapGesture {
                if viewModel.reachedEnd {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        //navigationViewIsActive = true
                    }
                    
                   //navigationViewIsActive = false
                    
                }
                if !viewModel.answerSelected {
                    isSelected = true
                    viewModel.selectAnswer(answer: answer)
                    backgroundColor = Color.white
                }
                if answer.isCorrect {
                    backgroundColor = .green
                    let impactMed = UIImpactFeedbackGenerator(style: .light)
                    impactMed.impactOccurred()
                } else {
                    backgroundColor = .red
                    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                    impactMed.impactOccurred()
                }
                isSelected = true
               
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isSelected = false
                }
                    
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                
                        
                    print("This is the index\(viewModel.index)")
                    viewModel.goToNextQuestion()
                    
                    
                }
            }
        }
    }
}

struct AnswerRow_Previews: PreviewProvider {
    static var previews: some View {
        AnswerRow(answer: Answer(text: "hi", isCorrect: true), viewModel: TriviaViewModel(groupName: "GROUP"))
            //.environmentObject(TriviaManager(for: "Bts"))
    }
}
