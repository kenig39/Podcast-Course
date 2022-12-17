//
//  PodcastCell.swift
//  Podcast Cours Overview
//
//  Created by Alexander on 22.12.2022.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {
    
    
    @IBOutlet weak var imageicon: UIImageView!
    
    
    @IBOutlet weak var TrackName: UILabel!
    
    
    @IBOutlet weak var ArtistName: UILabel!
    
    
    @IBOutlet weak var episodeCount: UILabel!
    
    
    
    var podcast: Podcast! {
        didSet {
            TrackName.text = podcast.trackName
            ArtistName.text = podcast.artistName
            
            episodeCount.text = "\(podcast.trackCount ?? 0) Episodes"
            
           guard let url = URL(string: podcast.artworkUrl600 ?? "") else {return}
//            URLSession.shared.dataTask(with: url) { data, _, _ in
//                guard let data = data else {return}
//                DispatchQueue.main.async {
//                    self.imageicon.image = UIImage(data: data)
//                }
//            }.resume()
            
            imageicon.sd_setImage(with: url)
        }
    }
}
    
    


