//
//  Episodes.swift
//  Podcast Cours Overview
//
//  Created by Alexander on 25.12.2022.
//

import Foundation
import FeedKit



struct Episode {
    let title: String
    let pudDate: Date
    let description: String
    let author: String
    let streamUrl: String
    
    var imageUrl: String?
    
    init(feedItem: RSSFeedItem){
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
        self.title = feedItem.title ?? ""
        self.pudDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        
    }
}
