//
//  Artist.swift
//  SpotifyProject
//
//  Created by Pelayo Mercado on 11/14/21.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let images: [APIImage]?
    let external_urls: [String: String]
}
