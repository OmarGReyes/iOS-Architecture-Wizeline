//
//  FavoritesDependencyContainer.swift
//  iOSArchitecture
//
//  Created by Omar Gonzalez on 4/07/22.
//

import Foundation

// MARK: FavoritesDependencyContainer
final class FavoritesDependencyContainer {
    // MARK: - Properties
    private var favoritesViewModel: FavoritesViewModel = FavoritesViewModel(songs: [])

    // MARK: - Methods
    // MARK: getFavoritesViewModel
    func getFavoritesViewModel() -> FavoritesViewModel {
        return favoritesViewModel
    }
    
    // MARK: makeFavoritesViewController
    func makeFavoritesViewController() -> FavoritesViewController {
        return FavoritesViewController(viewModel: favoritesViewModel)
    }
}
