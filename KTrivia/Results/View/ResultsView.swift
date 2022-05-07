//
//  ResultView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/12/22.
//
import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth

struct ResultsView: View {
    @StateObject var viewModel: TriviaViewModel
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.rootPresentationMode) private var rootPresentationMode: Binding<RootPresentationMode>
  
    
    init(viewModel: TriviaViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 100){
            HStack(alignment: .center, spacing: 40) {
                VStack {
                    ProfilePictureView(profilePic: viewModel.game?.player1["profile_pic"], size: 100, cornerRadius: 100)
                    Text(viewModel.game?.player1["username"] ?? "")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                Title(text: "VS", size: 30)
                VStack {
                    ProfilePictureView(profilePic: viewModel.game?.player2["profile_pic"], size: 100, cornerRadius: 100)
                    Text(viewModel.game?.player2["username"] ?? "")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
            }
            VStack{
                Title(text: "Final Scores", size: 30)
                HStack {
                    Title(text: viewModel.game?.player1TotalScore ?? "0", size: 60)
                    Title(text: "-", size: 60)
                    Title(text: viewModel.game?.player2TotalScore ?? "0", size: 60)
                }
                if Auth.auth().currentUser?.uid == viewModel.game?.player1["id"] && viewModel.game?.player1TotalScore == "3" {
                    Title(text: "YOU WON!", size: 30)
                } else if !viewModel.isPlayerOne && viewModel.game?.player2TotalScore == "3" {
                    Title(text: "YOU WON!", size: 30)
                } else {
                    Title(text: "YOU LOST! :(", size: 30)
                }
                
//                ButtonView(title: "Play Again", background: Color.secondaryColor) {
//                    viewModel.resetGame()
//                    self.presentationMode.wrappedValue.dismiss()
//                    
//                }

                ButtonView(title: "New Game", background: Color.secondaryColor) {
                    self.rootPresentationMode.wrappedValue.dismiss()
                }
//                .frame(height: 80)
//                .shadow(radius: 5, x: 2, y: 2)
//                .frame(width: 200)
//                .background(.white)
//                .cornerRadius(40)
            }
            .padding()
        }
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryColor)
        .ignoresSafeArea()
    }
}

