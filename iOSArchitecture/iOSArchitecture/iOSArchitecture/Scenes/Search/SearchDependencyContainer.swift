//
//  SearchDependencyContainer.swift
//  iOSArchitecture
//
//  Created by Omar Gonzalez on 28/06/22.
//

import Foundation

// MARK: SearchDependecyContainer
final class SearchDependecyContainer {
    
    // MARK: - Methods
    // MARK: makeMusicSearchRequest
    private func makeMusicSearchRequest() -> MusicSearchRequest {
        return MusicSearchRequest()
    }
    
    // MARK: makeMusicNetworkManager
    private func makeMusicNetworkManager() -> MusicNetworkManager {
        return MusicNetworkManager()
    }
    
    // MARK: makeMusicSearchRepository
    private func makeMusicSearchRepository() -> MusicSearchRepository {
        let musicSearchRequest = makeMusicSearchRequest()
        let musicNetworkManager = makeMusicNetworkManager()
        return MusicSearchRepository(musicSearchRequest: musicSearchRequest,
                                     musicNetworkManager: musicNetworkManager)
    }
    
    // MARK: makeSearchSongViewModel
    private func makeSearchSongViewModel() -> SearchSongViewModel {
        let musicRepository = makeMusicSearchRepository()
        return SearchSongViewModel(musicSearchRepository: musicRepository)
    }
    
    // MARK: makeSearchViewController
    func makeSearchViewController() -> SearchViewController {
        return SearchViewController(viewModel: makeSearchSongViewModel())
    }
}
