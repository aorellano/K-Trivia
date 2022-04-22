//
//  TriviaView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/10/22.
//

import SwiftUI

struct MultipleChoiceView: View {
    @StateObject var viewModel: TriviaViewModel
    @State private var shouldNavigate = false
    @State var selectedCategory: String
    @State var group: String
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timeRemaining = 30
    
    var answers = [
        Answer(text: "Answer1", isCorrect: true),
        Answer(text: "Answer2", isCorrect: false),
        Answer(text: "Answer3", isCorrect: false),
        Answer(text: "Answer4", isCorrect: false)
    ]
    
    init(groupName: String, selectedCategory: String, viewModel: TriviaViewModel) {
        self.group = groupName
        self.selectedCategory = selectedCategory
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
                VStack(spacing: 40) {
                    HStack {
                        Title(text: group, size: 20)
                        Spacer()
                        Title(text: "\(timeRemaining)", size: 20)
                    }
                    .padding([.leading, .trailing], 30)
                    .padding(.top, 20)
                    ProgressBar(progress: viewModel.progress)
                    VStack(spacing: 20) {
                        Text(viewModel.question?.question ?? "")
                            .foregroundColor(.white)
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                        if selectedCategory == "Song" {
                            PlayButtonView(file: viewModel.question?.file)
                        } else {
                            ScreenshotView(screenshotImage: viewModel.question?.file)
                        }
                        
                        Spacer()
                    
                        ForEach(viewModel.answers, id: \.id) { answer in
                            AnswerRow(answer: answer, viewModel: viewModel)
                                        .environmentObject(viewModel)
                        }
                    }
                    .padding([.leading, .trailing, .bottom], 30)
                }
                .padding([.leading, .trailing], 25)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationBarHidden(true)
                .background(
                    NavigationLink(destination: ResultsView(viewModel: viewModel),
                                      isActive: $shouldNavigate) { EmptyView() }
                )
        } .onReceive(timer) { time in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
            if timeRemaining == 0 {
                viewModel.endGame()
                self.shouldNavigate = true
                timer.upstream.connect().cancel()
            }
        }
        .onAppear {
            //viewModel.getTheGame()
        }
        .onDisappear {
            viewModel.endGame()
        }
        .background(Color.primaryColor)
    }
}


