//
//  LoginViewModel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/9/22.
//

import Foundation
import Combine

enum LoginState {
    case successfull
    case failed(error: Error)
    case na
}

protocol LoginViewModel {
    func login() -> Bool
    var service: LoginService { get }
    var state: LoginState { get }
    var credentials: LoginCredentials { get }
    init(service: LoginService)
}

final class LoginViewModelImpl: ObservableObject, LoginViewModel {
    @Published var state: LoginState = .na
    @Published var credentials: LoginCredentials = LoginCredentials.new
    
    let service: LoginService
    
    init(service: LoginService) {
        self.service = service
    }
    
    func login() -> Bool {
        return service.login(with: credentials)
    }
}
