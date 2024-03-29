//
//  TriviaView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/10/22.
//

import SwiftUI
import Introspect

struct MultipleChoiceView: View {
    @StateObject var viewModel: TriviaViewModel
    @State var showingAlert = false
    @State private var shouldNavigate = false
    @State private var timeRemaining = 15
    @State var tabBarController: UITabBarController?
    
    var answers = [
        Answer(text: "Answer1", isCorrect: true),
        Answer(text: "Answer2", isCorrect: false),
        Answer(text: "Answer3", isCorrect: false),
        Answer(text: "Answer4", isCorrect: false)
    ]
    
    @State private var isActive: Bool = false
    @State private var selectedCategory: String

    init(selectedCategory: String, viewModel: TriviaViewModel) {
        self.selectedCategory = selectedCategory
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
                VStack(spacing: 40) {
                    HStack {
                        Text(viewModel.game!.groupName)
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                        Spacer()
                        Text("\(timeRemaining)")
                            .font(.system(size: 30))
                            .fontWeight(.bold)
                            .foregroundColor(Color.secondaryColor)
                            
                        
                    }
                    .padding([.leading, .trailing], 30)
                    .padding(.top, 20)
                    
                    ProgressBar(progress: CGFloat(timeRemaining*20))
                    VStack(spacing: 20) {
                        Text(viewModel.question?.question ?? "")
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom, 20)
                        if selectedCategory == "Song" {
                            PlayButtonView(file: viewModel.question?.file)
                        } else if selectedCategory == "Performance" || selectedCategory == "MV" {
                            ScreenshotView(screenshotImage: viewModel.question?.file)
                                .frame(maxWidth: 400)
                                
                        }
                        
                       Spacer()
                    
                        ForEach(viewModel.answers, id: \.id) { answer in
                            AnswerRow(answer: answer, timeRemaining: timeRemaining, viewModel: viewModel)
                                        .environmentObject(viewModel)
                            
                        }
                        .padding([.leading, .trailing], 15)
                    }
                }
                .foregroundColor(.black)
                .background(Color.white)
                //.padding([.leading, .trailing], 25)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationBarHidden(true)
        }
        
        .onReceive(viewModel.timer) { time in
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = true
            tabBarController = UITabBarController
        }
    }
}



