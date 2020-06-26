//
//  SongsTableViewController.swift
//  Superfy
//
//  Created by MR.Robot 💀 on 25/06/2020.
//  Copyright © 2020 Joselson Dias. All rights reserved.
//

import UIKit

class SongsTableViewController: UITableViewController {
    
    

    @IBOutlet weak var songsTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        songsTable.delegate = self
        songsTable.dataSource = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }


}

//extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Table cell pressed")
//    }
//}
//
//extension ViewController: UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//       
//        let cell = tableView.dequeueReusableCell(withIdentifier: "songsTableViewCell", for: indexPath) as? TableViewCell
//        
//        cell?.songInformation.text = "Mandume"
//        cell?.songArtwork.image = UIImage(named: "orange")
//        
//        return cell!
//    }
//}
