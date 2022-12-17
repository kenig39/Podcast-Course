//
//  Podcast.swift
//  Podcast Cours Overview
//
//  Created by Alexander on 17.12.2022.
//

import Foundation

struct Podcast: Decodable {
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount: Int?
    var feedUrl: String?
}
