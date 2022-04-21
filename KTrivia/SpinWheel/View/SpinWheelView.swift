//
//  SpinWheel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/19/22.
//

import SwiftUI
import FortuneWheel

struct SpinWheelView: View {
    @StateObject var viewModel: TriviaViewModel
    @State var group: String
    @State private var didFinishChooshingCategory: Bool = false
    @State var isActive: Bool = false
    @State var selectedCategory: String? = nil
    var players  = ["Choice", "Lyrics", "Choice", "MV", "Choice", "Song", "Performance"]
    
    
    init(groupName: String, viewModel: TriviaViewModel) {
        self.group = groupName
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
            VStack {
                Title(text: "Spin the Wheel", size: 30)
                HStack(alignment: .center, spacing: 40) {
                    VStack {
                        ProfilePictureView(profilePic: viewModel.game?.player1["profile_pic"], size: 100, cornerRadius: 100)
                       
                        Text(viewModel.game?.player1["username"] ?? "")
                            .foregroundColor(.white)
                    }
                    Title(text: "VS", size: 30)
                    VStack {
                        ProfilePictureView(profilePic: viewModel.game?.player2["profile_pic"], size: 100, cornerRadius: 100)
                        Text(viewModel.game?.player2["username"] ?? "")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                FortuneWheel(titles: players, size: 320, onSpinEnd: { index in
                    selectedCategory = players[index]
                    
                    print("The Game is about to start for \(players[index])")
                
                    viewModel.getQuestions(for: group, and: selectedCategory ?? "")
                })
                    .padding()
                Text("The category is... \(group)")
                    .foregroundColor(.white)
                if selectedCategory == "MV" || selectedCategory == "Performance" {
                    NavigationLink(destination: ScreenshotQuestionView(groupName: group ?? "", selectedCategory: selectedCategory ?? "", viewModel: viewModel), isActive: $isActive) {
                    ButtonView(title: "Play", background: Color.secondaryColor) {
                        print("Hello")
                        //if selectedCategory != nil {
                                                            
                    
                        //}
                        isActive = true
                    }
                    .padding()
                    }
                } else if selectedCategory == "Lyrics"{
                    NavigationLink(destination: ScreenshotQuestionView(groupName: group ?? "", selectedCategory: selectedCategory ?? "", viewModel: viewModel), isActive: $isActive) {
                    ButtonView(title: "Play", background: Color.secondaryColor) {
                        print("Hello")
                        //if selectedCategory != nil {
                                                            
                    
                        //}
                        isActive = true
                    }
                    .padding()
                    }
                } else {
                    NavigationLink(destination: SongView(groupName: group ?? "", selectedCategory: selectedCategory ?? "", viewModel: viewModel), isActive: $isActive) {
                    ButtonView(title: "Play", background: Color.secondaryColor) {
                        print("Hello")
                        //if selectedCategory != nil {
                                                            
                    
                        //}
                        isActive = true
                    }
                    .padding()
                }
                }

                
            }.onAppear {
                viewModel.getTheGame()
            }
            .padding(.top, 20)
            .navigationBarHidden(true)
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryColor)
        
        .environment(\.rootPresentationMode, self.$isActive)
        .navigationViewStyle(StackNavigationViewStyle())
    }
        
}

//struct SpinWheel_Previews: PreviewProvider {
//    static var previews: some View {
//        SpinWheelView(groupName: "Twice", viewModel: SpinWheelViewModel(groupName: "Twice", sessionService: SessionServiceImpl()))
//    }
//}
