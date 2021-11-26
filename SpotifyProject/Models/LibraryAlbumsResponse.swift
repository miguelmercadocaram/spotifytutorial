//
//  LibraryAlbumsResponse.swift
//  SpotifyProject
//
//  Created by Pelayo Mercado on 11/26/21.
//

import Foundation

struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let added_at: String
    let album: Album
}
