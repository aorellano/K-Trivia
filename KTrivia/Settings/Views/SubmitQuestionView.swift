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
    @State var selectedGroup = ""
    @State var selectedOption = ""
    @State var shouldShowImagePicker = false
    @State var image = UIImage(named: "")
    var groups = ["BTS", "Twice", "Stray Kids"]
    var options = ["Choice", "Lyrics", "Performance", "MV", "Song"]
    @EnvironmentObject var dataService: DataServiceImpl
    
    var body: some View {
        VStack {
            Title(text: "Question Factory", size: 30)
                .padding(.top, -60)
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
                    if let image = self.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 160)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    HStack() {
                        Image(systemName: "photo")
                            .onTapGesture {
                                shouldShowImagePicker.toggle()
                        }
                        .foregroundColor(Color.secondaryColor)
                
                        Spacer()

                        }
                }
            
//            ZStack {
//                VStack {
//                ZStack{
//                    RoundedRectangle(cornerRadius: 10)
//                            .frame(width: 200, height: 100)
//                            .foregroundColor(.white)
//
//                    VStack{
//                    RoundedRectangle(cornerRadius: 10)
//                        .background(.white)
//                    if let image = self.image {
//                        Image(uiImage: image)
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 200, height: 100)
//                            .cornerRadius(75)
//                            .foregroundColor(.white)
//
//                        }
//
//
//
//                HStack() {
//                    Image(systemName: "photo")
//                        .onTapGesture {
//                            shouldShowImagePicker.toggle()
//                        }
//                        .foregroundColor(Color.secondaryColor)
//
//                    Spacer()
//                    Image(systemName: "music.note")
//                        .onTapGesture {
//                            print("opening library")
//                        }
//                        .foregroundColor(Color.secondaryColor)
//                }
//                .padding()
//                    }
//                }
//                }
//            }
            
            Text("Select Group and Question Type")
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .padding(.bottom, -5)
            Picker("Select Group", selection: $selectedGroup) {
                ForEach(groups, id:\.self) { group in
                    Text(group)
                        .foregroundColor(.white)
                }
            }.pickerStyle(.segmented)
                .frame(height: 40)
            Picker("Select Type", selection: $selectedOption) {
                ForEach(options, id:\.self) { type in
                    Text(type)
                        .foregroundColor(.white)
                }
            
                
            }.pickerStyle(.segmented)
                .frame(height: 40)
            VStack(spacing: 10){
                InputTextFieldView(text: $question, placeholder: "Question", keyboardType: .default, sfSymbol: .none)
                InputTextFieldView(text: $correctAnswer, placeholder: "Correct Answer", keyboardType: .default, sfSymbol: "checkmark.square.fill")
                InputTextFieldView(text: $incorrectAnswers[0], placeholder: "Incorrect Answer #1", keyboardType: .default, sfSymbol: "x.square.fill")
                InputTextFieldView(text: $incorrectAnswers[1], placeholder: "Incorrect Answer #2", keyboardType: .default, sfSymbol: "x.square.fill")
                InputTextFieldView(text: $incorrectAnswers[2], placeholder: "Incorrect Answer #3", keyboardType: .default, sfSymbol: "x.square.fill")
            }.padding(.top, -5)
            
            ButtonView(title: "Submit Question", background: Color.secondaryColor) {
              
                if image != UIImage(named: "") {
                    dataService.createQuestion(with: selectedGroup, type: selectedOption, question: question, correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers, screenshot: image!, audio: "")
                } else {
                dataService.createChoiceQuestion(with: selectedGroup, type: selectedOption, question: question, correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers)
                }
            }
            
            
        }
        
        .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
                
        }
        
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primaryColor)
    }
        
}

struct SubmitQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitQuestionView()
    }
}
