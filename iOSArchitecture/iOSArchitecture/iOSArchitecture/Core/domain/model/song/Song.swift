//
//  Song.swift
//  iOSArchitecture
//
//  Created by Osmar Hernandez on 22/06/22.
//

import Foundation

struct SongList: Decodable {
    let results: [Song]
}

struct Song: Decodable {
    let name: String
    let artist: String
    let previewUrl: String
    let artistId: Int
    let trackId: Int
    
    init(name: String, artist: String, previewUrl: String = "", artistId: Int, trackId: Int) {
        self.name = name
        self.artist = artist
        self.previewUrl = previewUrl
        self.artistId = artistId
        self.trackId = trackId
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case artist = "artistName"
        case previewUrl = "previewUrl"
        case artistId, trackId
    }
}
