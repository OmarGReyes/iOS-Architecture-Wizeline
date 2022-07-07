//
//  SignInDependencyContainer.swift
//  iOSArchitecture
//
//  Created by Omar Gonzalez on 28/06/22.
//

import UIKit

// MARK: SignInDependencyContainer
final class SignInDependencyContainer {
    
    // MARK: - Methods
    // MARK: makeSignInViewModel
    private func makeSignInViewModel() -> SignInViewModel{
        return SignInViewModel()
    }
    
    // MARK: makeSignInViewController
    func makeSignInViewController(_ childViewController: UITabBarController) -> SignInViewController {
        return SignInViewController(viewModel: makeSignInViewModel(), childViewController: childViewController)
    }
}
