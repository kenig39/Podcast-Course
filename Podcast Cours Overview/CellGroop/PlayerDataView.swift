//
//  PlayerDataView.swift
//  Podcast Cours Overview
//
//  Created by Alexander on 31.12.2022.
//

import UIKit
import AVKit

class PlayerDataView: UIView{
    
    var episode: Episode! {
        didSet {
            
            miniTitleLable.text = episode.title
            titleLable.text = episode.title
            authorLabel.text = episode.author
            
            
            
            guard let url = URL(string: episode.imageUrl ?? "" ) else
            {return}
            
            episodeImageView.sd_setImage(with: url)
            miniEpisodeImage.sd_setImage(with: url)
            
            playEpisode()
            
        }
    }
    
    fileprivate func playEpisode(){
        
        guard let url = URL(string: episode.streamUrl) else {return}
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
        
    }
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false // speed deferense
        return avPlayer
    }()
    
    
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main)
        { [weak self] (time) in
            
            self?.currentTimeLable.text = time.toDisplayString()
            let durationTime = self?.player.currentItem?.duration
            self?.durationLable.text = durationTime?.toDisplayString()
            
            
                self?.updateCurrentTimeSlider()
        }
        
    }
    
    fileprivate func updateCurrentTimeSlider(){
        let currenttimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1,timescale: 1))
        let percentage = currenttimeSeconds / durationSeconds
        
        self.currentTimeSlider.value = Float(percentage)
    }
    
    
    var panGesture: UIPanGestureRecognizer!
    
    fileprivate func setupGestures(){
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handelTapMaximaze))) // метод нажатия чтобы view появлялось
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handelPan))
        minimazedView.addGestureRecognizer(panGesture)
        
        maximazedStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handelDismissalPan)))
    }
    
    @objc func handelDismissalPan(gesture: UIPanGestureRecognizer){
        if gesture.state == .changed {
            let translation = gesture.translation(in: superview)
            maximazedStackView.transform = CGAffineTransform(translationX: 0, y:  translation.y)
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.maximazedStackView.transform = .identity
            })
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGestures()
        
        observePlayerCurrentTime()
        
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        //player has reference to self
        //self has a reference to player
        player.addBoundaryTimeObserver(forTimes: times, queue: .main)
        { [weak self] in
            self?.enlargeEpisodeImageView()
        }
    }
    //--------------------------------- // маленькое вью внизу страницы
    @objc func handelPan(gesture: UIPanGestureRecognizer){
         if gesture.state == .changed {
           handelPanChanged(gesture: gesture)
            
        }else if gesture.state == .ended{
           handelPanEnded(gesture: gesture)
        }
    }
    
    func handelPanChanged(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.superview)
         self.transform = CGAffineTransform(translationX: 0, y: translation.y)
         
         self.minimazedView.alpha = 1 + translation.y / 200
         self.maximazedStackView.alpha = -translation.y / 200
    }
    
    func handelPanEnded(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)//Отследите движение пальцев по экрану и примените это движение к своему контенту.
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            
            self.transform = .identity
            
            if translation.y < -200 || velocity.y < -500 {
               
                let mainTabBarController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.rootViewController as? MainTabBarController
                
                mainTabBarController?.maximizePlayerDetails(episode: nil)
                gesture.isEnabled = false // что бы не было реагирования на перетаскивание вниз
                
            } else {
                self.minimazedView.alpha = 1
                self.maximazedStackView.alpha = 0
            }
            
            self.minimazedView.alpha = 1
            self.maximazedStackView.alpha = 0
        })
    }
    //----------------------------------------------------------
    
    
    @objc func handelTapMaximaze(){
        let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.rootViewController as? MainTabBarController
        window?.maximizePlayerDetails(episode: nil)
        panGesture.isEnabled = false
    }
    
    static func initFromNib() -> PlayerDataView {
        return Bundle.main.loadNibNamed("PlayerDataView", owner: self, options: nil)?.first as! PlayerDataView

    }

    deinit {

    }

    //Изменение картинки в размерах
    fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    fileprivate func enlargeEpisodeImageView(){
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1) {
            self.episodeImageView.transform = .identity
        }
    }
    
    fileprivate func shrinkEpisodeImageView(){
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = self.shrunkenTransform
        })
    }
    
  //------------------------------
    
    fileprivate func seekToCurrentTime(delta: Int64){
        let fifteenSecond = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSecond)
        player.seek(to: seekTime)
        
    }
    
    // MARK: IB Actions and outlet
    
    
    
    @IBOutlet weak var miniEpisodeImage: UIImageView!
    
    @IBOutlet weak var miniTitleLable: UILabel!
   
    @IBOutlet weak var miniPlayButton: UIButton!{
        didSet {
            miniPlayButton.addTarget(self, action: #selector(handelPlayPause), for: .touchUpInside)
        }
    }
    
    
    @IBOutlet weak var miniForvardButton: UIButton!{
        didSet {
            miniForvardButton.addTarget(self, action: #selector(SliderCangeForvard), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var minimazedView: UIView!
    
    
    
    @IBOutlet weak var maximazedStackView: UIStackView!
    
    
    
    
    @IBAction func SliderCangeForvard(_ sender: Any) {
     seekToCurrentTime(delta: 15)
      
    }
    
    
    @IBAction func sliderChangeBack(_ sender: Any) {
       seekToCurrentTime(delta: -15)
    }
    
  
    
    
    
    @IBOutlet weak var authorLabel: UILabel!
    
    
    @IBOutlet weak var durationLable: UILabel!
    
    @IBOutlet weak var currentTimeSlider: UISlider!
    
    

    @IBAction func handelVolumeChange(_ sender: UISlider) {
        
        player.volume = sender.value
        
    }
    
    
    @IBAction func handelTimeSliderChange(_ sender: Any) {
        let persentage = currentTimeSlider.value
        
        guard let duration = player.currentItem?.duration else {return}
        
        let durationInSecond = CMTimeGetSeconds(duration)
        
        let seekTimeINSeconds = Float64(persentage) * durationInSecond
        
        let seekTime = CMTimeMakeWithSeconds(seekTimeINSeconds, preferredTimescale: Int32(NSEC_PER_SEC))
        player.seek(to: seekTime)
        
    }
    
    @IBOutlet weak var currentTimeLable: UILabel!
    
  
    


    @IBOutlet weak var playPauseButton: UIButton!{
        didSet{
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            playPauseButton.addTarget(self, action: #selector(handelPlayPause), for: .touchUpInside)
        }
    }
    
    
    @objc func handelPlayPause(){
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            miniPlayButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
            enlargeEpisodeImageView()
        } else {
            player.pause()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            miniPlayButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            shrinkEpisodeImageView()
        }
        
    }
    
   
    
    @IBAction func handelDismiss(_ sender: Any) {
       // self.removeFromSuperview()
        let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.rootViewController as? MainTabBarController
        window?.minimazePlayerDetail()
        panGesture.isEnabled = true
        
    }
  
    
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet{
            episodeImageView.layer.cornerRadius = 5
            episodeImageView.clipsToBounds = true
           
            episodeImageView.transform = shrunkenTransform
        }
    }
    
    @IBOutlet weak var titleLable: UILabel! {
        didSet {
            titleLable.numberOfLines = 2
        }
    }
    
}
