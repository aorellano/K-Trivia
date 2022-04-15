//
//  TriviaView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/10/22.
//

import SwiftUI

struct TriviaView: View {
    @StateObject var viewModel: TriviaViewModel
    @State private var shouldNavigate = false
    @State var group: String
    
    
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
                        Title(text: "\(viewModel.timeRemaining)", size: 20)
                        
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
                .background(
                    NavigationLink(destination: ResultsView(viewModel: viewModel),
                                      isActive: $shouldNavigate) { EmptyView() }
                )
        } .onReceive(viewModel.timer) { time in
            if viewModel.timeRemaining > 0 {
                viewModel.timeRemaining -= 1
                
            }
            
            if viewModel.timeRemaining == 0 {
                viewModel.endGame()
                self.shouldNavigate = true
                viewModel.timer.upstream.connect().cancel()
            }
        }
        
        .onAppear {
            viewModel.getTheGame()
        }
    }
}


