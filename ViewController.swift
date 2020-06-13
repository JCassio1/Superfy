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
               
        setAudioSession()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        becomeFirstResponder()
        
        let notificationCenterAlerts = NotificationCenter.default
        
        notificationCenterAlerts.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
        
        notificationCenterAlerts.addObserver(self, selector: #selector(routeChange), name: AVAudioSession.routeChangeNotification, object: AVAudioSession.sharedInstance())
        
        configureUI()

        //init
        player = Player()
        let url = "https://www.osiris-shop.com/music_app/Mandume.mp3"
    
        player?.loadSong(songURL: url)
        
        if player!.theMediaPlayer.rate > 0 { playPauseButon.setImage(pauseIcon, for: .normal) }
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    func setAudioSession(){
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        }
            
        catch {
            print(error)
        }
    }
    
    func configureUI() {
        let imageName = "orange"
        let getImage = UIImage(named: imageName)
        coverImage.image = getImage
        
        //Make Cover Image round corners
        addRoundCorners(dimensions: 8.0)
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
    
    override func remoteControlReceived(with event: UIEvent?) {
        
        if event!.type == UIEvent.EventType.remoteControl {
    
            if event!.subtype == UIEvent.EventSubtype.remoteControlPause {
                print("Pause...")
                player?.pauseSong()
            }
            
            else if event!.subtype == UIEvent.EventSubtype.remoteControlPlay {
                print("Play")
                player?.playSong()
            }
        }
    }
    
    // If audio is interrupted by phone call or other app
    @objc func handleInterruption(notification: NSNotification) {
        player?.pauseSong()
        
        if notification.name != AVAudioSession.interruptionNotification
            || notification.userInfo == nil{
            return
        }

        var info = notification.userInfo!
        var intValue: UInt = 0
        (info[AVAudioSessionInterruptionTypeKey] as! NSValue).getValue(&intValue)
        if let interruptionType = AVAudioSession.InterruptionType(rawValue: intValue) {

            switch interruptionType {

            case .began:
                print("began")
                // player is paused and session is inactive. need to update UI)
                player?.pauseSong()
                print("audio paused")

            default:
                print("ended")
                player?.playSong()
                print("audio resumed")
            }
        }
    }
    
    @objc func routeChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
            let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
                return
        }

        // Switch over the route change reason.
        switch reason {

        case .newDeviceAvailable: // New device found.
            let session = AVAudioSession.sharedInstance()
                player?.playSong()
                changePlayButton(playing: true)

        case .oldDeviceUnavailable: // Old device removed.
            if let previousRoute =
                userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
                player?.pauseSong()
                changePlayButton(playing: false)
            }

        default: ()
        }
    }
    
}
