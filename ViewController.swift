//
//  ViewController.swift
//  Superfy
//
//  Created by MR.Robot 💀 on 08/06/2020.
//  Copyright © 2020 Joselson Dias. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var playPauseButon: UIButton!
    
    var player : Player?
    
    let pauseIcon = UIImage(systemName: "pause.fill")
    let playIcon = UIImage(systemName: "play.fill")
 

    override func viewDidLoad() {
        super.viewDidLoad()
                    
        let imageName = "orange"
        let getImage = UIImage(named: imageName)
        coverImage.image = getImage
        
        //Make Cover Image round corners
        addRoundCorners(dimensions: 8.0)

        //init
        player = Player()
        let url = "https://www.osiris-shop.com/music_app/Mandume.mp3"
    
        player?.loadSong(songURL: url)
        
        if player!.theMediaPlayer.rate > 0 { playPauseButon.setImage(pauseIcon, for: .normal) }
    }
       
    func addRoundCorners(dimensions: Float) {
        coverImage.layer.cornerRadius = CGFloat(dimensions)
    }
    
    

    @IBAction func playPauseButtonTapped(_ sender: Any) {
        
        if (player!.theMediaPlayer.rate > 0) {
            player?.pauseSong()
            changePlayButton(playing: true)
        }
        
        else {
            player?.playSong()
            changePlayButton(playing: false)
        }
    }
    
    func changePlayButton(playing: Bool) {
        playing ? playPauseButon.setImage(playIcon, for: .normal) : playPauseButon.setImage(pauseIcon, for: .normal)
    }
    
}











