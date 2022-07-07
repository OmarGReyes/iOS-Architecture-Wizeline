//
//  Album.swift
//  iOSArchitecture
//
//  Created by Omar Gonzalez on 30/06/22.
//

import Foundation

struct AlbumList: Decodable {
    let results: [Album]
}

struct Album: Decodable {
    let collectionName: String?
    let artistName: String
    let artworkUrl60: String?
    
    init(collectionName: String,
         artistName: String,
         artworkUrl60: String) {
        self.collectionName = collectionName
        self.artistName = artistName
        self.artworkUrl60 = artworkUrl60
    }
}
