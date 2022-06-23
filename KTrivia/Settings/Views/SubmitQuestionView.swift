//
//  SubmitQuestionView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 5/9/22.
//

import SwiftUI

struct SubmitQuestionView: View {
    @State var question = ""
    @State var correctAnswer = ""
    @State var incorrectAnswers = ["", "", ""]
    @State var shouldShowImagePicker = false
    @State var image = UIImage(named: "")
    @State var showAlert = false
    var selectedGroup: String
    var selectedOption: String
    @EnvironmentObject var dataService: DataServiceImpl
    
    init(selectedGroup: String, selectedOption: String) {
        self.selectedGroup = selectedGroup
        self.selectedOption = selectedOption
        print(self.selectedGroup)
        print(self.selectedOption)
    }
    
    var body: some View {
//        if type == "MV" || type == "Performance" {
//
//        }
        VStack {
            if selectedOption == "MV" || selectedOption == "Performance" {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(height: 200)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                if let image = self.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .cornerRadius(20)
                        .padding(.top, 20)
                        .foregroundColor(.white)
                }
    
                Image(systemName: "photo")
                    .onTapGesture {
                        shouldShowImagePicker.toggle()
                    }
                    .foregroundColor(Color.secondaryColor)
                    .padding(.leading, -180)
                    .padding(.top, 180)
            
            }
        }
            Spacer()
            VStack(spacing: 10){
                InputTextFieldView(text: $question, placeholder: "Question", keyboardType: .default, sfSymbol: .none)
                InputTextFieldView(text: $correctAnswer, placeholder: "Correct Answer", keyboardType: .default, sfSymbol: "checkmark.square.fill")
                InputTextFieldView(text: $incorrectAnswers[0], placeholder: "Incorrect Answer #1", keyboardType: .default, sfSymbol: "x.square.fill")
                InputTextFieldView(text: $incorrectAnswers[1], placeholder: "Incorrect Answer #2", keyboardType: .default, sfSymbol: "x.square.fill")
                InputTextFieldView(text: $incorrectAnswers[2], placeholder: "Incorrect Answer #3", keyboardType: .default, sfSymbol: "x.square.fill")
            }
            
            Spacer()
            ButtonView(title: "Submit Question", background: Color.secondaryColor) {
                if question == "" || correctAnswer == "" || incorrectAnswers[0] == "" || incorrectAnswers[1] == "" || incorrectAnswers[2] == "" {
                    showAlert = true
                } else if image != UIImage(named: "") {
                    dataService.createQuestion(with: selectedGroup, type: selectedOption, question: question, correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers, screenshot: image!, audio: "")
                    image = UIImage(named: "")
                    question = ""
                    correctAnswer = ""
                    incorrectAnswers = ["","",""]
                } else {
                    dataService.createChoiceQuestion(with: selectedGroup, type: selectedOption, question: question, correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers)
                    question = ""
                    correctAnswer = ""
                    incorrectAnswers = ["","",""]
                }
            }
            
        }
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
        .alert("Please fill out all fields", isPresented: $showAlert) {
                            Button("OK", role: .cancel) { }
                        }
        
                
        
        .foregroundColor(.black)
        .navigationTitle("Create a Question")
        .navigationBarTitleDisplayMode(.inline)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    
        
}

