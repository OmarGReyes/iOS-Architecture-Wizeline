//
//  CustomCellProvider.swift
//  iOSArchitecture
//
//  Created by Omar Gonzalez on 2/07/22.
//

import UIKit

// MARK: CustomCellsProvider
final class CustomCellsProvider {
    // MARK: - Properties
    var albums: [Album]?
    var songs: [Song]
    
    // MARK: Initializer
    init(songs: [Song], albums: [Album]? = nil) {
        self.albums = albums
        self.songs = songs
    }
    
    // MARK: - Methods
    // MARK: provideSongSection
    private func provideSongSection() -> CustomCellSection {
        var items: [DataCellViewModable] = []
        for song in songs {
            items.append(SongCellModel(reuseIdentifier: SongCell.reuseIdentifier,
                                       song: song))
        }
        return CustomCellSection(title: "Songs section", items: items)
    }
    
    // MARK: provideAlbumSection
    private func provideAlbumSection() -> CustomCellSection? {
        guard let albums = albums,
              !albums.isEmpty else { return nil }
        var items: [DataCellViewModable] = []
        for n in 1...5 {
            items.append(AlbumCellModel(reuseIdentifier: AlbumCell.reuseIdentifier, albumName: albums[n].collectionName ?? ""))
        }
        return CustomCellSection(title: "Album section", items: items)
    }
    
    // MARK: provide
    func provide() -> [CustomCellSection] {
        var sections: [CustomCellSection] = []
        if let albumSection = provideAlbumSection() {
            sections.append(albumSection)
        }
        
        sections.append(provideSongSection())
        return sections
    }
}
