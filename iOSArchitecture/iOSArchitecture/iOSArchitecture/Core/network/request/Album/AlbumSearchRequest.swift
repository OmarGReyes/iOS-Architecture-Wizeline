//
//  AlbumSearchRequest.swift
//  iOSArchitecture
//
//  Created by Omar Gonzalez on 30/06/22.
//

import Foundation

final class AlbumSearchRequest: RequestProtocol {
    var artistId: String
    
    init(artistId: String = "") {
        self.artistId = artistId
    }
    
    var path: String {
        return "/lookup"
    }
    
    var parameters: [String: String] {
        return [
            "id" : artistId,
            "entity" : "album"
        ]
    }
}
