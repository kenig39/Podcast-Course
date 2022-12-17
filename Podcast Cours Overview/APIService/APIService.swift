//
//  APIService.swift
//  Podcast Cours Overview
//
//  Created by Alexander on 22.12.2022.
//

import Foundation
import Alamofire
import FeedKit

class  APIService {
    let baseiTunesSearchURL = "https://itunes.apple.com/search"
    
    
    static let shared = APIService()
    
    func fetchEpisodes(feedUrl: String, complitionHandler: @escaping([Episode]) ->()){
        
        
        let secureFeedUrl = feedUrl.contains("https") ? feedUrl :
        feedUrl.replacingOccurrences(of: "http", with: "https")
        
        guard let url = URL(string: secureFeedUrl) else {return}
        
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            
            parser?.parseAsync(result: { (result) in
                
                
                if let err = result.error{
                    print("Error " , err)
                    return
                }
                guard let feed = result.rssFeed else {return}
                
                let episodes = feed.toEpisodes()
                complitionHandler(episodes)
            })
        }
    }
       
    func fetchPodcast(searchText: String, completionHnadler: @escaping([Podcast]) -> ()){
        
        let parameters = ["term": searchText, "media": "podcast"]
        
        AF.request(baseiTunesSearchURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to contact podcast" , err)
                return
            }
            
            guard let data = dataResponse.data else {return}
            do {
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                print(searchResult.resultCount)
                completionHnadler(searchResult.results)
               
            } catch let decodeErr {
                print("faled to decode", decodeErr)
                
            }
            
        }
        
    }
       
        
    
    
    struct SearchResults: Decodable{
        let resultCount: Int
        let results: [Podcast]
    }
    
}
