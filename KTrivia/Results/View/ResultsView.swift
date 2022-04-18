//
//  ResultView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/12/22.
//
import SwiftUI
import SDWebImageSwiftUI

struct ResultsView: View {
    @StateObject var viewModel: TriviaViewModel
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.rootPresentationMode) private var rootPresentationMode: Binding<RootPresentationMode>
    
    init(viewModel: TriviaViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 100){
            HStack(alignment: .center, spacing: 20) {
                VStack {
                    ProfilePictureView(profilePic: viewModel.currentUser?.profilePic, size: 100, cornerRadius: 100)
                    Text(viewModel.player1?.username ?? "")
                }
                Title(text: "VS", size: 30)
                VStack {
                    ProfilePictureView(profilePic: viewModel.player2?.profilePicUrl, size: 100, cornerRadius: 100)
                    Text(viewModel.player2?.username ?? "")
                }
            }
            VStack{
                Title(text: "Final Scores", size: 30)
                HStack {
                    Title(text: viewModel.yourScore ?? "", size: 60)
                    Title(text: "-", size: 60)
                    Title(text: viewModel.opponentScore ?? "", size: 60)
                }
                Title(text: viewModel.results ?? "", size: 60)
                Button (action: { self.rootPresentationMode.wrappedValue.dismiss() } ) {
                    Text("Play again")
                }
                .frame(height: 80)
                .shadow(radius: 5, x: 2, y: 2)
                .frame(width: 200)
                .background(.white)
                .cornerRadius(40)
            }
        }
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryColor)
        .ignoresSafeArea()
    }
}

