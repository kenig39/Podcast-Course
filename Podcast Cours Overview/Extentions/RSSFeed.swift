//
//  RSSFeed.swift
//  Podcast Cours Overview
//
//  Created by Alexander on 28.12.2022.
//

import FeedKit

extension RSSFeed {
    func toEpisodes() -> [Episode] {
        
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        
        
        var episodes = [Episode]() //blank Episode array
        items?.forEach({(feedItem) in
            var episode = Episode(feedItem: feedItem)
            
            if episode.imageUrl == nil {
                episode.imageUrl = imageUrl
            }
            
            episodes.append(episode)
        })
        
        return episodes
    }
}
