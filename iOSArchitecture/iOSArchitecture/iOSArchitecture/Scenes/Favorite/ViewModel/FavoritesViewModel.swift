//
//  FavoritesViewModel.swift
//  iOSArchitecture
//
//  Created by Omar Gonzalez on 4/07/22.
//

import Foundation
import Combine

// MARK: FavoritesViewModel
final class FavoritesViewModel {
    // MARK: - Properties
    @Published public private(set) var sections: [CustomCellSection]?
    private var songs: [Song] {
        didSet {
            updateSections()
        }
    }
    
    // MARK: - Initializer
    init(songs: [Song]) {
        self.songs = songs
    }
    
    // MARK: - Public methods
    
    // MARK: deleteSong
    func deleteSong(songToDelete: Song) {
        self.songs = songs.filter { song  in
            song.trackId != songToDelete.trackId
        }
    }
    
    // MARK: - Private methods

    // MARK: addSongTofavorite
    private func addSongTofavorite(song: Song) {
        self.songs.append(song)
    }
    
    // MARK: updateSections
    private func updateSections() {
        sections = CustomCellsProvider(songs: songs, albums: nil).provide()
    }
    
    // MARK: shouldAddSongToFavorites
    private func shouldAddSongToFavorites(songToAdd: Song) -> Bool {
        for song in songs {
            if song.trackId == songToAdd.trackId {
                return false
            }
        }
        return true
    }
}

// MARK: - SearchViewControllerDelegate
extension FavoritesViewModel: SearchViewControllerDelegate {
    func addSongToFavorites(with song: Song) {
        if shouldAddSongToFavorites(songToAdd: song) {
            self.addSongTofavorite(song: song)
        }
    }
}
