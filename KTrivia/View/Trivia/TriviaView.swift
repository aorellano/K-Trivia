//
//  TriviaView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/10/22.
//

import SwiftUI

struct TriviaView: View {
    @StateObject var viewModel: TriviaViewModel
    @State var group: String
    @State var timeRemaining = 30
    //@Binding var navigationViewActive: Bool
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var answers = [
        Answer(text: "Answer1", isCorrect: true),
        Answer(text: "Answer2", isCorrect: false),
        Answer(text: "Answer3", isCorrect: false),
        Answer(text: "Answer4", isCorrect: false)
    ]
    
    init(groupName: String, viewModel: TriviaViewModel) {
        self.group = groupName
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
                BackgroundView()
                VStack(spacing: 40) {
                    HStack {
                        Title(text: group, size: 20)
                        Spacer()
                        Title(text: "\(timeRemaining)", size: 20)
                        
//                        Spacer()
//                        Text("\(viewModel.index + 1)/5")
//                            .foregroundColor(.black)
//                            .font(.system(size: 18))
//                            .fontWeight(.bold)
                    }
                    .padding(.top, 20)
                    ProgressBar(progress: viewModel.progress)
//
//
                    VStack(alignment: .leading, spacing: 20) {
                        Text(viewModel.question?.question ?? "")
                            .foregroundColor(.black)
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                        Spacer()
                        ForEach(viewModel.answers, id: \.id) { answer in
                            AnswerRow(answer: answer, viewModel: viewModel)
                                        .environmentObject(viewModel)
                        }
                    }
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationBarHidden(true)
        }.onReceive(timer) { time in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
        }
    }
}

struct TriviaView_Previews: PreviewProvider {
    static var previews: some View {
        let group = "Twice"
        let viewModel = TriviaViewModel(groupName: group)
        viewModel.questions = [
            Trivia(category: "Twice", type: "Multiple", question: "Who is  Twice?", correctAnswer: "That Bitch", incorrectAnswers: [""])
        ]
        return TriviaView(groupName: group, viewModel: viewModel)
    }
}
