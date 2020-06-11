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
    
    var player : Player?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //init
        player = Player()
        
        let url = "https://www.osiris-shop.com/music_app/Mandume.mp3"
        
        player?.loadSong(songURL: url)
        
    }
       

    
}











