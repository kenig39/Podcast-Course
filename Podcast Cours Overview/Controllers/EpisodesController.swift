//
//  EpisodesController.swift
//  Podcast Cours Overview
//
//  Created by Alexander on 23.12.2022.
//

import UIKit
import FeedKit

class EpisodesController: UITableViewController {
    
    fileprivate let cellID = "Cell"
 
    var episode = [Episode]()
    
    
    var podcast: Podcast? {
        didSet{
            navigationItem.title = podcast?.trackName
            
           fetchEpisodes()
        }
    }
    
    fileprivate func fetchEpisodes(){
       
        guard let feedUrl = podcast?.feedUrl else {return}
        
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
            self.episode = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
            
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()
        
    }
    
    //MARK:- Table View
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activitiIndicator = UIActivityIndicatorView(style: .large)
        activitiIndicator.color = .black
        activitiIndicator.startAnimating()
       // activitiIndicator.stopAnimating()
        return activitiIndicator

    }
       
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episode.isEmpty ? 200 : 0
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episode.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EpisodeCell
        
        let episode = episode[indexPath.row]
        cell.episode = episode
        
       
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let episode = self.episode[indexPath.row]
        let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.rootViewController as? MainTabBarController
        window?.maximizePlayerDetails(episode: episode)
//
//       let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//        let window = windowScene?.windows.first
//        let playerDetail = Bundle.main.loadNibNamed("PlayerDataView", owner: self)?.first as! playerDataView
//
//        playerDetail.episode = episode
//
//        playerDetail.frame = self.view.frame
//        window?.addSubview(playerDetail)
        
    }
}
