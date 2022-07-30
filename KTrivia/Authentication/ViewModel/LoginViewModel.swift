//
//  LoginViewModel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/9/22.
//

import Foundation
import Combine
import SwiftUI
import UIKit
import simd

enum LoginState {
    case successfull
    case failed(error: Error)
    case na
}

protocol LoginViewModel {
    func login()
    var service: LoginService { get }
    var state: LoginState { get }
    var credentials: LoginCredentials { get }
    var hasError: Bool { get }
    init(service: LoginService)
}

final class LoginViewModelImpl: ObservableObject, LoginViewModel {
    @Published var hasError: Bool = false
    @Published var state: LoginState = .na
    @Published var credentials: LoginCredentials = LoginCredentials.new
    private var subscriptions = Set<AnyCancellable>()
    
    let service: LoginService
    
    init(service: LoginService) {
        self.service = service
        setupErrorSubscriptions()
    }
    
    func login() {
        service.login(with: credentials)
            .sink { result in
                switch result {
                case .failure(let err):
                    self.state = .failed(error: err)
                default: break
                }
            } receiveValue: { [weak self] in
                self?.state = .successfull
            }
            .store(in: &subscriptions)
    }
}

private extension LoginViewModelImpl {
    func setupErrorSubscriptions() {
        $state.map { state -> Bool in
            switch state {
            case .successfull, .na:
                return false
            case .failed:
                return true
            }
        }
        .assign(to: &$hasError)
    }
}
