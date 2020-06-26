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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentSongName: UILabel!
    
    
    
    var player : Player?
    var songs: [Song] = []
    
    let pauseIconForLight = UIImage(systemName: "pause.fill")
    let playIconForLight = UIImage(systemName: "play.fill")
    let pauseIconForDark = UIImage(systemName: "pause.fill")!.withTintColor(.white, renderingMode: .alwaysOriginal)
    let playIconForDark = UIImage(systemName: "play.fill")!.withTintColor(.white, renderingMode: .alwaysOriginal)
 

    override func viewDidLoad() {
        super.viewDidLoad()
               
        setAudioSession()
        UIApplication.shared.beginReceivingRemoteControlEvents()
        becomeFirstResponder()
        
        let notificationCenterAlerts = NotificationCenter.default
        
        notificationCenterAlerts.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: AVAudioSession.sharedInstance())
        
        notificationCenterAlerts.addObserver(self, selector: #selector(routeChange), name: AVAudioSession.routeChangeNotification, object: AVAudioSession.sharedInstance())
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if traitCollection.userInterfaceStyle == .light {
            print("Light mode")
            playPauseButon.setImage(playIconForLight, for: .normal)
        } else {
            print("Dark mode")
            playPauseButon.setImage(playIconForDark, for: .normal)
        }
        
        configureUI()

        //init
        player = Player()
//        let url = "https://www.osiris-shop.com/music_app/Mandume.mp3"
        retrieveSongs()

        
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
        
        if traitCollection.userInterfaceStyle == .light {
            print("Light mode")
            playing ? playPauseButon.setImage(playIconForLight, for: .normal) : playPauseButon.setImage(pauseIconForLight, for: .normal)
        } else {
            print("Dark mode")
            playing ? playPauseButon.setImage(playIconForDark, for: .normal) : playPauseButon.setImage(pauseIconForDark, for: .normal)
        }
    }
    
    // If audio is interrupted by phone call or other app
    @objc func handleInterruption(notification: NSNotification) {
        player?.pauseSong()
        
        if notification.name != AVAudioSession.interruptionNotification
            || notification.userInfo == nil{
            return
        }

        let info = notification.userInfo!
        var intValue: UInt = 0
        (info[AVAudioSessionInterruptionTypeKey] as! NSValue).getValue(&intValue)
        if let interruptionType = AVAudioSession.InterruptionType(rawValue: intValue) {

            switch interruptionType {

            case .began:
                print("began")
                // player is paused and session is inactive. need to update UI)
                player?.pauseSong()
                changePlayButton(playing: true)
                print("audio paused")

            default:
                print("ended")
                player?.playSong()
                changePlayButton(playing: false)
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
    
    
    override func remoteControlReceived(with event: UIEvent?) {
        
        if event!.type == UIEvent.EventType.remoteControl {
    
            if event!.subtype == UIEvent.EventSubtype.remoteControlPause {
                print("Pause... remote")
                player?.pauseSong()
            }
            
            else if event!.subtype == UIEvent.EventSubtype.remoteControlPlay {
                print("Play... remote")
                player?.playSong()
            }
        }
    }
    
    //If changed to dark mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.userInterfaceStyle == .light {
            print("Light mode")
            playPauseButon.setImage(playIconForLight, for: .normal)
        } else {
            print("Dark mode")
            playPauseButon.setImage(playIconForDark, for: .normal)
        }
    }
    
    func retrieveSongs() {
        
        guard let url = URL(string: "https://osiris-shop.com/music_app/get-music.php") else {
            print("URL is invalid!")
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(
            with: request,
                    completionHandler: { data, response, error in
                        let retrievedList = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        self.parseSongs(data: retrievedList!)
                    })
        task.resume()
        print("Getting songs")
    }
    
    func parseSongs(data: NSString) {
        
//        * separates each song from the function
        if (data.contains("#")) {

            let dataArray = (data as String).components(separatedBy: "#")
            
            for songItem in dataArray {
                
                let songsData = songItem.components(separatedBy: ",")
                
                let LikesWithoutSpaces = songsData[2].trimmingCharacters(in: .whitespacesAndNewlines) //Data returning with spaces
                let playsWithoutSpaces = songsData[3].trimmingCharacters(in: .whitespacesAndNewlines) //Data returning with spaces
                
                let newSong = Song(id: songsData[0], name: songsData[1], numberOfLikes: LikesWithoutSpaces, numberOfPlays: playsWithoutSpaces)

                songs.append(newSong!)
            }
            
            DispatchQueue.main.async { [unowned self] in
                self.tableView.reloadData()
            }
        }
    }
}



//Delegate and Source for tableview
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        changePlayButton(playing: false)
        player?.loadSong(songURL: "https://www.osiris-shop.com/music_app/" + songs[indexPath.row].getName())
        currentSongName.text = songs[indexPath.row].getCleanSongName()
    
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "songsTableViewCell", for: indexPath) as? TableViewCell

        cell?.songArtwork.image = UIImage(named: "orange")
        cell?.songInformation.text = songs[indexPath.row].getCleanSongName()

        return cell!
    }
}
//END
