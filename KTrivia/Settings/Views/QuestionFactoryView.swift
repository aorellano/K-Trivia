//
//  QuestionFactoryView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 5/7/22.
//

import SwiftUI

struct QuestionFactoryView: View {
    var groups = ["BTS", "Twice", "Stray Kids"]
    var options = ["Choice", "Lyrics", "Performance", "MV", "Song"]
    @State var selectedGroup = "BTS"
    @State var selectedOption = "Choice"
    @State var isActive = false
    var body: some View {
        VStack {
            if selectedGroup != "" && selectedOption != "" {
                NavigationLink(destination: NavigationLazyView(SubmitQuestionView(selectedGroup: selectedGroup, selectedOption: selectedOption)), isActive: $isActive) {
                    EmptyView()
                }.isDetailLink(false)
            }
            
            VStack {
                Text("Select Group")
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                    .padding(.top, 30)
                   // .padding(.bottom, -10)
                Picker("Select Group", selection: $selectedGroup) {
                    ForEach(groups, id:\.self) { group in
                        Text(group)
                    }
                }.pickerStyle(.wheel)
                .frame(height: 200)
            }
            
            Spacer()
            
            VStack {
                Text("Select Question Type")
                    .fontWeight(.semibold)
                    .padding(.top, -60)
                    .padding(.bottom, 20)
                Picker("Select Type", selection: $selectedOption) {
                    ForEach(options, id:\.self) { type in
                        Text(type)
                    }
                    
                }.pickerStyle(.wheel)
                .frame(height: 100)
            }
            Spacer()
            
                
                    ButtonView(title: "Enter", background: Color.secondaryColor) {
                        isActive = true
                    }

            
            
        }
        .padding()
        .navigationTitle("Choose Options")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct QuestionFactoryView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionFactoryView()
    }
}
