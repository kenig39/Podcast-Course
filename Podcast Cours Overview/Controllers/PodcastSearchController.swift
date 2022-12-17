//
//  PodcastSearchController.swift
//  Podcast Cours Overview
//
//  Created by Alexander on 17.12.2022.
//

import UIKit
import Alamofire

class PodcastSearchController: UITableViewController,UISearchBarDelegate{
    
    var arrPodcast = [Podcast]()
    
    let cellID = "Cell"
    
    // lets implement a UIsearchController
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        
        setupTableView()
        
        searchBar(searchController.searchBar, textDidChange: "news")
        
    }
    
    var timer: Timer?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
         arrPodcast = []
        tableView.reloadData()
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            APIService.shared.fetchPodcast(searchText: searchText) {(podcast) in
                self.arrPodcast = podcast
                self.tableView.reloadData()
            }
        })
        
      
    }
    
        fileprivate func setupSearchBar(){
            self.definesPresentationContext = true
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.delegate = self
        }
        
        fileprivate func setupTableView(){
          //  tableView.register(PodcastCell.self, forCellReuseIdentifier: cellID)
            tableView.tableFooterView = UIView()
            let nib = UINib(nibName: "PodcastCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: cellID)
        }
        
    // Mark tableView
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodesController = EpisodesController()
        let podcast = self.arrPodcast[indexPath.row]
        episodesController.podcast = podcast
        navigationController?.pushViewController(episodesController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter a Search Term"
        label.textAlignment = .center
        label.textColor = UIColor.purple
        label.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        return label
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //ternary operator
        return self.arrPodcast.isEmpty && searchController.searchBar.text?.isEmpty == true ? 250 : 0
       // return self.arrPodcast.count > 0 ? 0 : 250
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return arrPodcast.isEmpty && searchController.searchBar.text?.isEmpty ==
        false ? 200 : 0
    }
    
    
    var podcastSearchView = Bundle.main.loadNibNamed("PodcastsSearchingView", owner: PodcastSearchController.self)?.first as? UIView
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return podcastSearchView
    }
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrPodcast.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PodcastCell
            
            let podcast = self.arrPodcast[indexPath.row]
            cell.podcast = podcast
            
//            cell.textLabel?.text = "\(podcast.trackName ?? "") \n \(podcast.artistName ?? "")"
//            cell.textLabel?.numberOfLines = -1
//            cell.imageView?.image = UIImage(systemName: "wave.3.forward.circle")
            return cell
        }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
        
    }

