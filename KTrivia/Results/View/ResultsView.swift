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
        VStack(spacing: 80){
            Spacer()
            HStack(alignment: .center, spacing: 40) {
                VStack {
                    ProfilePictureView(profilePic: viewModel.game?.player1["profile_pic"], size: 100, cornerRadius: 100)
                    Text(viewModel.game?.player1["username"] ?? "")
                        .fontWeight(.bold)
                }
                Title(text: "VS", size: 30)
                VStack {
                    ProfilePictureView(profilePic: viewModel.game?.player2["profile_pic"], size: 100, cornerRadius: 100)
                    Text(viewModel.game?.player2["username"] ?? "")
                        .fontWeight(.bold)
                }
            }
            ZStack {
                RoundedRectangle(cornerRadius: 150)
                    .frame(width: 300, height: 300)
                    .foregroundColor(Color.secondaryColor)
                Image(uiImage: UIImage(named: "mang")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .padding(.top, -200)
                VStack{
                    Title(text: "Final Scores", size: 30)
                    HStack {
                        Title(text: viewModel.game?.player1TotalScore ?? "0", size: 60)
                        Title(text: "-", size: 60)
                        Title(text: viewModel.game?.player2TotalScore ?? "0", size: 60)
                    }
                
                    if viewModel.game?.winnerId == Auth.auth().currentUser?.uid {
                        Title(text: "YOU WON!", size: 30)
                    } else {
                        Title(text: "YOU LOST! :(", size: 30)
                    }
                }
                .foregroundColor(.white)
            }
               
                ButtonView(title: "New Game", background: Color.secondaryColor) {
                    self.rootPresentationMode.wrappedValue.dismiss()
                }
                .padding()
                
            
            
        }
        .padding()
        
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red:242/255, green: 242/255, blue: 247/255))
        .ignoresSafeArea()
    }
}

