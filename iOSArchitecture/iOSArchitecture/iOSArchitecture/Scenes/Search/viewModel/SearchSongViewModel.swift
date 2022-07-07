//
//  SearchSongViewModel.swift
//  iOSArchitecture
//
//  Created by Osmar Hernandez on 22/06/22.
//

import Combine
import Foundation

// MARK: SearchSongViewModel
final class SearchSongViewModel {
    // MARK: Properties
    @Published public var songInput: String = ""
    @Published public private(set) var sections: [CustomCellSection]?
    private var musicSearchRepository: MusicSearchRepository
    private var subscriptions = Set<AnyCancellable>()
    public private(set) var songResults: [Song] = []
    
    // MARK: Initializer
    init(musicSearchRepository: MusicSearchRepository) {
        self.musicSearchRepository = musicSearchRepository
        
        $songInput
            .sink(receiveValue: searchForSong(_:))
            .store(in: &subscriptions)
    }
    
    // MARK: - Methods
    // MARK: searchForSong
    private func searchForSong(_ song: String) {
        musicSearchRepository.search(song)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] songList in
                    self?.updateSongResult(songList.results)
                    self?.isArtistSearch(songList.results)
                }
            ).store(in: &subscriptions)
    }
    
    // MARK: searchForAlbums
    private func searchForAlbums(_ id: Int) {
        musicSearchRepository.searchAlbums("\(id)")
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] albumList in
                self?.updateAlbumResult(albumList.results)
            })
            .store(in: &subscriptions)
    }
    
    // MARK: updateSongResult
    private func updateSongResult(_ songResults: [Song]) {
        self.songResults = songResults
    }
    
    // MARK: updateAlbumResult
    private func updateAlbumResult(_ albumResults: [Album]) {
        self.sections = CustomCellsProvider(songs: songResults, albums: albumResults).provide()
    }
    
    // MARK: isArtistSearch
    private func isArtistSearch(_ songResults: [Song]) {
        guard !songResults.isEmpty else { return }
        let artistInformation = findArtistName(songResults)
        
        for index in 1...4 {
            if songResults[index].artist.contains(artistInformation.name) {
                continue
            } else {
                self.sections = CustomCellsProvider(songs: songResults, albums: nil).provide()
                return
            }
        }
        
        searchForAlbums(artistInformation.id)
    }
   
    // MARK: findArtistName
    /// As artist with a lot of features with other artist have differents "artistId". "artistId" isn't it the best way track if a search is by artist or by song
    /// Ex: if you search "Anuel" you find that his first song is with Karol G and have artistId: 996166916 and the second one is with Nicki Minaj
    /// And the artistId is: 278464538 and we are looking for "Anuel" that is an artist and his Id: 996166916
    /// This function search for ther shorter name of the list in order to avoid any type of feature with other artists.
    private func findArtistName(_ songResults: [Song]) -> (name: String, id: Int) {
        var artistName: String = songResults.first?.artist ?? ""
        var artistId: Int = songResults.first?.artistId ?? .zero
        for song in songResults {
            if song.artist.count < artistName.count {
                artistName = song.artist
                artistId = song.artistId
            }
        }
        return (name: artistName, id: artistId)
    }
}
