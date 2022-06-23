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
    @State var image: UIImage?
    @State var showAlert = false
    @State var showingAlert2 = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
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
                                                .stroke(Color.gray, lineWidth: 1.5))
                            } else {
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .font(.system(size: 150, weight: .light))
                                    .padding(.top, -20)
                                    .padding(.bottom, 25)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    VStack(spacing: 16) {
                        InputTextFieldView(text: $vm.userDetails.username,
                                       placeholder: "Username",
                                       keyboardType: .namePhonePad,
                                       sfSymbol: "person")
                        InputTextFieldView(text: $vm.userDetails.email,
                                       placeholder: "Email",
                                       keyboardType: .emailAddress,
                                       sfSymbol: "envelope")
                        InputPasswordView(password: $vm.userDetails.password,
                                       placeholder: "Password",
                                       sfSymbol: "lock")
                    
                    }
                    ButtonView(title: "Sign Up", background: Color.secondaryColor) {
                        if image == UIImage(named: "") {
                            showAlert = true
                        } else if vm.userDetails.username == "" || vm.userDetails.email == "" || vm.userDetails.password == "" {
                            showingAlert2 = true
                        } else {
                            vm.profilePicture = image
                            vm.register()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                        
                    }
                    .alert("Please Choose Profile Picture", isPresented: $showAlert) {
                                Button("OK", role: .cancel) { }
                    }
                    .alert("Please fill out all text fields", isPresented: $showingAlert2) {
                        Button("OK", role: .cancel) { }
                    }
                }
                .padding(.horizontal, 15)
            }
            .navigationTitle("Register")
            .applyClose().foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            //.background(Color.background)
        }.fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
                .ignoresSafeArea(.keyboard)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
