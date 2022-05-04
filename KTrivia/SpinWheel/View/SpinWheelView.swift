//
//  SpinWheel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/19/22.
//

import SwiftUI
import FortuneWheel
import Combine

struct SpinWheelView: View {
    @StateObject var viewModel: TriviaViewModel
    @State var group: String
    @State private var didFinishChooshingCategory: Bool = false
    @State var isActive: Bool = false
    @State var selectedCategory: String? = nil
    var players  = ["Choice", "Lyrics", "Choice", "MV", "Choice", "Song", "Performance"]
    @State var viewHasAppeared = 0
    @State var showingAlert1 = false
    @State var buttonColor: Color = Color.gray
    @State var isBlocked = false
    
    init(groupName: String, viewModel: TriviaViewModel) {
        self.group = groupName
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack{
            VStack {
                Title(text: "Spin the Wheel", size: 30)
                HStack(alignment: .center, spacing: 40) {
                    VStack {
                        ProfilePictureView(profilePic: viewModel.game?.player1["profile_pic"], size: 100, cornerRadius: 100)
                       
                        Text(viewModel.game?.player1["username"] ?? "")
                            .foregroundColor(.white)
                        QuestionBombs(totalScore: viewModel.totalScore)

                    }
                    Title(text: "VS", size: 30)
                    VStack {
                        ProfilePictureView(profilePic: viewModel.game?.player2["profile_pic"], size: 100, cornerRadius: 100)
                        Text(viewModel.game?.player2["username"] ?? "")
                            .foregroundColor(.white)
                        //QuestionBombs(totalScore: 1)
                    }
                }
                .padding()
              
               
                FortuneWheel(titles: players, size: 320, onSpinEnd: { index in
                    selectedCategory = players[index]
                    
                    print("The Game is about to start for \(players[index])")
                
                    viewModel.getQuestions(for: group, and: selectedCategory ?? "")
                    buttonColor = Color.secondaryColor
                    
                })
                .disabled(viewModel.checkForGameStatus())
                            
                Text(viewModel.gameNotification)
                    .foregroundColor(.white)
            
                   
                    
                        
                        
                        
                        
          
                .padding()
                if viewModel.score == 0 {
                    ScoreIndicatorView(colors: [.white, .white, .white])
                } else if viewModel.score == 1 {
                    ScoreIndicatorView(colors: [Color.secondaryColor, .white, .white])
                } else if viewModel.score == 2 {
                    ScoreIndicatorView(colors: [Color.secondaryColor, Color.secondaryColor, .white])
                } else {
                    ScoreIndicatorView(colors: [Color.secondaryColor, Color.secondaryColor, Color.secondaryColor])
                }
                   
                
                NavigationLink(destination: MultipleChoiceView(group: group ?? "", selectedCategory: selectedCategory ?? "", viewModel: viewModel), isActive: $isActive){
//                    if selectedCategory != nil {
//                        buttonColor = Color.secondaryColor
//                    }
                    ButtonView(title: "Play", background: buttonColor) {
                        isActive = true
                    }
                    .padding()
                }.isDetailLink(false)
                    .disabled(selectedCategory == nil)
                .alert("Would you like to recieve a question bomb or challenge your opponent for their question bomb?", isPresented: $showingAlert1) {
                        Button("Recieve") { viewModel.updateTotalScore() }
                        Button("Challenge"){ print("Challenging for Question Bomb")}
                }
                
            }
            .onAppear {
                selectedCategory = nil
                buttonColor = Color.gray
                print("score is: \(viewModel.score)")
                if viewHasAppeared == 0 {
                    viewModel.getTheGame()
                    
                }
                viewHasAppeared += 1
           
                if viewModel.score == 3 {
                    print("gonna show this")
                    showingAlert1.toggle()
                }

            }
            .padding(.top, 20)
            .navigationBarHidden(true)
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryColor)
        
//        .environment(\.rootPresentationMode, self.$isActive)
//        .navigationViewStyle(StackNavigationViewStyle())
    }
    }
        
}

//struct SpinWheel_Previews: PreviewProvider {
//    static var previews: some View {
//        SpinWheelView(groupName: "Twice", viewModel: SpinWheelViewModel(groupName: "Twice", sessionService: SessionServiceImpl()))
//    }
//}
