//
//  MainTabBarViewController.swift
//  Podcast Cours Overview
//
//  Created by Alexander on 17.12.2022.
//

import UIKit


class MainTabBarController: UITabBarController {
    
    var maximizedTopAncorConstraint:NSLayoutConstraint!
    var minimizedTopAncorCOnstraint:NSLayoutConstraint!
    var bottomAnchorConstraint: NSLayoutConstraint!
    
    let playerDetailView = PlayerDataView.initFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().prefersLargeTitles = true
        
        
        tabBar.tintColor = .purple
        
        setupViewControllers()
        
        setupPlayerDetailView()
        
       // perform(#selector(minimazePlayerDetail), with: nil, afterDelay: 1)
        //Метод задержки в появлении
       
    }
    
    @objc func minimazePlayerDetail(){
        
        maximizedTopAncorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAncorCOnstraint.isActive = true
        
       
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1) {
            
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            
            
            self.playerDetailView.maximazedStackView.alpha = 0
            self.playerDetailView.minimazedView.alpha = 1
        }
        
    }
    
    func maximizePlayerDetails(episode:Episode?){
       
        minimizedTopAncorCOnstraint.isActive = false
        maximizedTopAncorConstraint.isActive = true
        maximizedTopAncorConstraint.constant = 0
        
       
        
        bottomAnchorConstraint.constant = 0 // указали что ноль это низ
        
        if episode != nil{
            playerDetailView.episode = episode
        }
       
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            
            self.playerDetailView.maximazedStackView.alpha = 1
            self.playerDetailView.minimazedView.alpha = 0
            
        })
    }
    
   fileprivate func setupPlayerDetailView(){
      
      

        // use auto layuot

        view.insertSubview(playerDetailView, belowSubview: tabBar)

        //enables auto layout
        playerDetailView.translatesAutoresizingMaskIntoConstraints = false

        maximizedTopAncorConstraint = playerDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAncorConstraint.isActive = true
       
       bottomAnchorConstraint =
         playerDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:  view.frame.height)
       bottomAnchorConstraint.isActive = true

        minimizedTopAncorCOnstraint = playerDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
      //  minimizedTopAncorCOnstraint.isActive = true

        playerDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

          
       
        playerDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

    }

    
    func setupViewControllers(){
        viewControllers = [
           
            generateNavigationController(with: PodcastSearchController(), title: "Search", Image: UIImage(systemName: "magnifyingglass")!),
            generateNavigationController(with: ViewController(), title: "Favorites", Image: UIImage(systemName: "play.circle.fill")!),
            generateNavigationController(with: ViewController(), title: "Download", Image: UIImage(systemName: "arrow.down.square.fill")!)
        ]
    }
    
    
    fileprivate func generateNavigationController(with rootViewcontroller: UIViewController, title: String, Image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewcontroller)
        rootViewcontroller.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = Image
        return navController
    }
}
