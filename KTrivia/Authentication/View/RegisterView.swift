//
//  RegisterView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/16/22.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var vm = RegistrationViewModelImpl(
        service: RegistrationServiceImpl()
    )
    @State var shouldShowImagePicker = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 30) {
                    Button {
                        shouldShowImagePicker.toggle()
                    } label: {
                        VStack {
                            if let image = self.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .cornerRadius(75)
                                    .overlay(RoundedRectangle(cornerRadius: 75)
                                                .stroke(Color.black, lineWidth: 1.5))
                            } else {
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .font(.system(size: 150, weight: .light))
                                    .padding(.top, -20)
                                    .padding(.bottom, 25)
                            }
                        }
                    }
                    VStack(spacing: 16) {
                        InputTextFieldView(text: $vm.userDetails.username,
                                       placeholder: "Username",
                                       keyboardType: .namePhonePad,
                                       sfSymbol: "envelope")
                        InputTextFieldView(text: $vm.userDetails.email,
                                       placeholder: "Email",
                                       keyboardType: .emailAddress,
                                       sfSymbol: "envelope")
                        InputPasswordView(password: $vm.userDetails.password,
                                       placeholder: "Password",
                                       sfSymbol: "lock")
                    
                        
                    
                    }
                    ButtonView(title: "Sign Up", background: Color.secondaryColor) {
                        vm.profilePicture = image
                        vm.register()
                    }
                }
                .padding(.horizontal, 15)
            }
            
            .navigationTitle("Register")
            .applyClose().foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 132/255, green: 52/255, blue: 245/255))
        }.fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
    }
    
    @State var image: UIImage?
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
