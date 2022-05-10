//
//  QuestionFactoryView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 5/7/22.
//

import SwiftUI

struct QuestionFactoryView: View {
    var options = ["Submit Questions", "Review Questions "]
    var body: some View {
        VStack {
            Title(text: "Question Factory", size: 30)
                .padding(.top, -20)
                .padding(.bottom, 60)
            ScrollView {
                ForEach(options, id: \.self) { option in
   
                        HStack {
                            Text(option)
                                .fontWeight(.bold)
                            Spacer()
                            
                        }
                        .padding()
                    
                    .accentColor(Color.black)
                    .frame(height: 80)
                    .background(.white)
                    .cornerRadius(15)
                    .shadow(radius: 5, x: 2, y: 2)
                    .padding([.leading, .trailing], 20)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryColor)
    }
}

struct QuestionFactoryView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionFactoryView()
    }
}
