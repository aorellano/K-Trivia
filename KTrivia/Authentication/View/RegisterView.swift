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
    var body: some View {
        NavigationView {
            ZStack {
   
                VStack(spacing: 32) {
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
                    ButtonView(title: "Sign Up", background: .purple) {
                        vm.register()
                    }
                }
                .padding(.horizontal, 15)
            }
            
            .navigationTitle("Register")
            .applyClose()
            .background(Color(red: 132/255, green: 52/255, blue: 245/255))
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
