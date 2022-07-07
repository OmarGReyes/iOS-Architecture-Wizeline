//
//  AppDependencyContainer.swift
//  iOSArchitecture
//
//  Created by Omar Gonzalez on 28/06/22.
//

import UIKit

// MARK: AppDependencyContainer
final class AppDependencyContainer {
    // MARK: - Properties
    let signInDependencyContainer: SignInDependencyContainer
    let searchDependencyContainter: SearchDependecyContainer
    let favoritesDependecyContainer: FavoritesDependencyContainer
    
    // MARK: - Initializer
    init () {
        self.signInDependencyContainer = SignInDependencyContainer()
        self.searchDependencyContainter = SearchDependecyContainer()
        self.favoritesDependecyContainer = FavoritesDependencyContainer()
    }
    
    // MARK: Methods
    // MARK: - makeNaivgationController
    private func makeNaivgationController(_ rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.backgroundColor = .black
        navigationController.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController.navigationBar.barTintColor = .black
        navigationController.navigationBar.isTranslucent = false
        
        return navigationController
    }
    
    // MARK: - makeInitialViewController
    func makeInitialViewController() -> SignInViewController {
        let searchViewController = searchDependencyContainter.makeSearchViewController()
        let favoritesViewController = favoritesDependecyContainer.makeFavoritesViewController()
        searchViewController.delegate = favoritesDependecyContainer.getFavoritesViewModel()
        let navigationControllerSearch = makeNaivgationController(searchViewController)
        let navigationControllerFavorite = makeNaivgationController(favoritesViewController)
        let mainViewController = MainViewController(favoritesViewController: navigationControllerFavorite, searchViewController: navigationControllerSearch)
        return signInDependencyContainer.makeSignInViewController(mainViewController)
    }
}
