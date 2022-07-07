//
//  viewModel.swift
//  iOSArchitecture
//
//  Created by Omar Gonzalez on 28/06/22.
//

import Foundation
import Combine

// MARK: SignInViewModel
final class SignInViewModel {
    
    // MARK: - Properties
    @Published public private(set) var isAuthorized: Bool = false
    
    var username: String = ""
    var password: String = ""
    
    // MARK: - Public methods
    @objc public func signIn() {
        if username == Credentials.username.value && password == Credentials.password.value {
            isAuthorized = true
        } else {
            print("Incorrect credentials")
        }
    }
}

// MARK: - Credentials Extension
extension SignInViewModel {
    // MARK: - Credentials
    private enum Credentials {
        case username
        case password
        
        var value: String {
            switch self {
            case .username:
                return ""
            case .password:
                return ""
            }
        }
    }
}
