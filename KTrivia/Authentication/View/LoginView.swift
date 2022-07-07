//
//  LoginView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/16/22.
//

import SwiftUI

struct LoginView: View {
    @State private var showRegistration = false
    @State private var emptyTextFieldAlert = false
    @State private var incorrectInputAlert = false
    @StateObject private var vm = LoginViewModelImpl(
        service: LoginServiceImpl()
    )
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 16) {
                    VStack(spacing: 16) {
                        InputTextFieldView(text: $vm.credentials.email, placeholder: "Email", keyboardType: .emailAddress, sfSymbol: "envelope")
                        InputPasswordView(password: $vm.credentials.password, placeholder: "Password", sfSymbol: "lock")
                    }
     
                    VStack(spacing: 16) {
                        ButtonView(title: "Login", background: Color.secondaryColor) {
                            if vm.credentials.email == "" || vm.credentials.password == "" {
                                emptyTextFieldAlert = true
                            }
                            if !vm.login() {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    incorrectInputAlert = true
                                }
                            }
                        }
                        ButtonView(title: "Register",
                                   background: .white,
                                   foreground: Color.secondaryColor,
                                   border: .white) {
                            showRegistration.toggle()
                        }
                        
                        .alert("Please fill out all text fields", isPresented: $emptyTextFieldAlert) {
                                Button("OK", role: .cancel) { }
                        }
                        .alert("Incorrect Email or Password", isPresented: $incorrectInputAlert) {
                                Button("Try Again", role: .cancel) { }
                        }
                        .sheet(isPresented: $showRegistration, content: {
                            RegisterView()
                        })
                    }
                }
                .padding(.horizontal, 15)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background)
                .navigationBarTitle("Login")
                
            }
        }
    }
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
