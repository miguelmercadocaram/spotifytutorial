//
//  SearchResult.swift
//  SpotifyProject
//
//  Created by Pelayo Mercado on 11/22/21.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
    
}
