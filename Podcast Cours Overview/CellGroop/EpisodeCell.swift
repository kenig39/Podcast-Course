//
//  EpisodeCell.swift
//  Podcast Cours Overview
//
//  Created by Alexander on 25.12.2022.
//

import UIKit


class EpisodeCell: UITableViewCell {
    
    var episode: Episode! {
        didSet {
            
            pubDateLable.text = episode.pudDate.description
            titleLable.text = episode.title
            descriptionLable.text = episode.description
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MM , yyyy"
            pubDateLable.text = dateFormatter.string(from: episode.pudDate)
            
            let url = URL(string: episode.imageUrl?.toSecureHTTPS() ?? "")
            imageViewIcon.sd_setImage(with: url)
            
        }
        
    }
    
    @IBOutlet weak var imageViewIcon: UIImageView!
    
    @IBOutlet weak var pubDateLable: UILabel!
   
    @IBOutlet weak var titleLable: UILabel!
    
  
    @IBOutlet weak var descriptionLable: UILabel!
      
    

   
    
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//    
}
