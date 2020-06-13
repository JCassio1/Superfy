//
//  Player.swift
//  Superfy
//
//  Created by MR.Robot 💀 on 08/06/2020.
//  Copyright © 2020 Joselson Dias. All rights reserved.
//

import Foundation
import MediaPlayer

class Player
{
    var theMediaPlayer: AVPlayer!
    
    init () {
        theMediaPlayer = AVPlayer()
    }
    
    func loadSong(songURL: String) {

        guard let url = URL.init(string: songURL) else { return }
        let playerItem = AVPlayerItem.init(url: url)
        theMediaPlayer = AVPlayer.init(playerItem: playerItem)
        theMediaPlayer?.play()
        
        setPlayingMusicInfo(fileUrl: songURL)
        
        print("Playing song..")
    }
    
    func playSong() {
        if (theMediaPlayer.rate == 0 && theMediaPlayer.error == nil) {
            theMediaPlayer.play()
        }
    }
    
    func pauseSong() {
        if (theMediaPlayer.rate > 0 && theMediaPlayer.error == nil) {
            theMediaPlayer.pause()
        }
    }
    
    
    func setPlayingMusicInfo(fileUrl: String){
        
        let urlArray = fileUrl.split{$0 == "/"}.map(String.init)
        
        let name = urlArray[urlArray.endIndex-1]
        
        print(name)
        
        let songInfo = [
            MPMediaItemPropertyTitle: name,
            MPMediaItemPropertyArtist: "Superfy"
        ]
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
    }
    
}
