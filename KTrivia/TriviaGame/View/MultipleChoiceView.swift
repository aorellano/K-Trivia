//
//  TriviaView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/10/22.
//

import SwiftUI

struct MultipleChoiceView: View {
//    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    //@Environment(\.rootPresentationMode) private var rootPresentationMode: Binding<RootPresentationMode>
    @StateObject var viewModel: TriviaViewModel
    @State var showingAlert = false
    
    @State private var shouldNavigate = false
    @State private var timeRemaining = 15
    var answers = [
        Answer(text: "Answer1", isCorrect: true),
        Answer(text: "Answer2", isCorrect: false),
        Answer(text: "Answer3", isCorrect: false),
        Answer(text: "Answer4", isCorrect: false)
    ]
    
    @State private var isActive: Bool = false
    @State private var selectedCategory: String
    @State private var group: String

    init(group: String, selectedCategory: String, viewModel: TriviaViewModel) {
        self.group = group
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
                    ProgressBar(progress: CGFloat(timeRemaining*20))
                    VStack(spacing: 20) {
                        Text(viewModel.question?.question ?? "")
                            .foregroundColor(.white)
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                            .padding([.leading, .trailing], 15)
                        if selectedCategory == "Song" {
                            PlayButtonView(file: viewModel.question?.file)
                        } else {
                            ScreenshotView(screenshotImage: viewModel.question?.file)
                        }
                        
                        Spacer()
                    
                        ForEach(viewModel.answers, id: \.id) { answer in
                            AnswerRow(answer: answer, timeRemaining: timeRemaining, viewModel: viewModel)
                                        .environmentObject(viewModel)
                            
                        }
                        .padding([.leading, .trailing], 15)
                        
                    }
                    
                    
                }
                //.padding([.leading, .trailing], 25)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationBarHidden(true)
//                .background(
//                    NavigationLink(destination: ResultsView(viewModel: viewModel),
//                                   isActive: $shouldNavigate) { EmptyView() }.isDetailLink(false)
//                )
                //.padding([.leading, .trailing, .bottom], 30)
                
            
                
        }
        
        .onReceive(viewModel.timer) { time in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .onAppear {
            //viewModel.getTheGame()
            
            
        }

        .background(Color.primaryColor)
        //.environment(\.presentationMode, self.$isActive)
//        .navigationViewStyle(StackNavigationViewStyle())
    }
}



