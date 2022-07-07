//
//  MusicSearchRepository.swift
//  iOSArchitecture
//
//  Created by Osmar Hernandez on 22/06/22.
//

import Combine
import Foundation

// MARK: MusicSearchRepository
final class MusicSearchRepository: SearchRepository {
    
    // MARK: - Properties
    private var musicSearchRequest: MusicSearchRequest
    private var musicNetworkManager: MusicNetworkManager
    private var albumSearchRequest: AlbumSearchRequest = AlbumSearchRequest()
    
    // MARK: - Initializer
    init(musicSearchRequest: MusicSearchRequest, musicNetworkManager: MusicNetworkManager) {
        self.musicSearchRequest = musicSearchRequest
        self.musicNetworkManager = musicNetworkManager
    }
    
    // MARK: - Methods
    // MARK: search
    func search(_ song: String) -> AnyPublisher<SongList, Error> {
        musicSearchRequest.song = song
        let request = try! musicSearchRequest.createUrlRequest()
        return musicNetworkManager.search(request)
    }
    
    // MARK: searchAlbums
    func searchAlbums(_ artistId: String) -> AnyPublisher<AlbumList, Error> {
        albumSearchRequest.artistId = artistId
        let request = try! albumSearchRequest.createUrlRequest()
        return musicNetworkManager.searchAlbum(request)
    }
}
