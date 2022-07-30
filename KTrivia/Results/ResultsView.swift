//
//  ResultView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/12/22.
//
import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth
import Introspect

struct ResultsView: View {
    @StateObject var viewModel: TriviaViewModel
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.rootPresentationMode) private var rootPresentationMode: Binding<RootPresentationMode>
    
    init(viewModel: TriviaViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 40){
//            Spacer()
            HStack(alignment: .center, spacing: 40) {
                VStack {
                    ProfilePictureView(profilePic: viewModel.game?.player1["profile_pic"], size: 85, cornerRadius: 85)
                    Text(viewModel.game?.player1["username"] ?? "")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .font(.system(size: 14))
                }
                Title(text: "VS", size: 28)
                    .foregroundColor(.black)
                VStack {
                    ProfilePictureView(profilePic: viewModel.game?.player2["profile_pic"], size: 85, cornerRadius: 85)
                    Text(viewModel.game?.player2["username"] ?? "")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .font(.system(size: 14))
                }
            }
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 125)
                    .frame(width: 250, height: 250)
                    .foregroundColor(Color.secondaryColor)
                    
                Image(uiImage: UIImage(named: "mang")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .padding(.top, -175)
                VStack{
                    Title(text: "Final Scores", size: 28)
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
            

            
            
        }
        .padding()
        
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .ignoresSafeArea()
    }
}

