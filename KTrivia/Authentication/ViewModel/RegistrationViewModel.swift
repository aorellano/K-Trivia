//
//  RegistrationViewModel.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/17/22.
//

import Foundation
import SwiftUI

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
    init(service: RegistrationService)
}


final class RegistrationViewModelImpl: ObservableObject, RegistrationViewModel {
    var service: RegistrationService
    var state: RegistrationState = .na
    var profilePicture = UIImage(contentsOfFile: "")
    @Published var userDetails: RegistrationDetails = RegistrationDetails.new
    
    init(service: RegistrationService) {
        self.service = service
    }
    
    func register() {
        service.register(with: userDetails, and: profilePicture!)
    }
}
