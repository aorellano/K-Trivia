//
//  RegistrationViewModel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/17/22.
//

import Foundation
import SwiftUI
import Combine
import simd

enum RegistrationState {
    case successful
    case failed(error: Error )
    case na
}

protocol RegistrationViewModel {
    func register()
    var service: RegistrationService { get }
    var state: RegistrationState { get }
    var userDetails: RegistrationDetails { get }
    var profilePicture: UIImage? { get set }
    var hasError: Bool { get }
    init(service: RegistrationService)
}


final class RegistrationViewModelImpl: ObservableObject, RegistrationViewModel {
    var service: RegistrationService
    var profilePicture = UIImage(contentsOfFile: "")
    @Published var hasError: Bool = false
    @Published var userDetails: RegistrationDetails = RegistrationDetails.new
    @Published var state: RegistrationState = .na
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: RegistrationService) {
        self.service = service
        setupErrorSubscriptions()
    }
    
    func register() {
        service.register(with: userDetails, and: profilePicture!)
            .sink { [weak self] res in
                switch res {
                case .failure(let error):
                    self?.state = .failed(error: error)
                default: break
                }
            } receiveValue: { [weak self] in
                self?.state = .successful
            }
            .store(in: &subscriptions)
    }
}

private extension RegistrationViewModelImpl {
    func setupErrorSubscriptions() {
        $state.map { state -> Bool in
            switch state {
            case .successful, .na:
                return false
            case .failed:
                return true
            }
        }
        .assign(to: &$hasError)
    }
}
