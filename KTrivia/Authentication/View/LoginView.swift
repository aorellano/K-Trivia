//
//  LoginView.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/16/22.
//

import SwiftUI

struct LoginView: View {
    @State private var showRegistration = false
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
                            vm.login()
                        }
                        ButtonView(title: "Register",
                                   background: .white,
                                   foreground: Color.secondaryColor,
                                   border: .white) {
                            showRegistration.toggle()
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
                .alert(isPresented: $vm.hasError, content: {
                    return Alert(title: Text("Email or Password was incorrect"))
                })

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
