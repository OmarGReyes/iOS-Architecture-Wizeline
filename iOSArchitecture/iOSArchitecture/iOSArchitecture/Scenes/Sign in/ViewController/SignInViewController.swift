//
//  SignInViewController.swift
//  iOSArchitecture
//
//  Created by Omar Gonzalez on 28/06/22.
//

import UIKit
import Combine

// MARK: SignInViewController
final class SignInViewController: NiblessViewController {
    // MARK: - Propertie
    private var viewModel: SignInViewModel
    private var subscriptions = Set<AnyCancellable>()
    private let childViewController: UITabBarController
    
    // MARK: - Initializer
    init(viewModel: SignInViewModel, childViewController: UITabBarController) {
        self.viewModel = viewModel
        self.childViewController = childViewController
        super.init()
    }
    
    // MARK: - Lifecycle methods
    override func loadView() {
        super.loadView()
        self.view = SignInRootView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        (view as! SignInRootView).wireController(viewModel)
    }
    
    // MARK: - Methods
    
    // MARK: subscribe
    private func subscribe() {
        viewModel
            .$isAuthorized
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                if result { self?.presentSearchScene() }
            }
            .store(in: &subscriptions)
    }
    
    // MARK: presentSearchScene
    private func presentSearchScene() {
        childViewController.isModalInPresentation = true
        present(childViewController, animated: true)
    }
}
