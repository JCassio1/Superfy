//
//  Song.swift
//  Superfy
//
//  Created by MR.Robot 💀 on 21/06/2020.
//  Copyright © 2020 Joselson Dias. All rights reserved.
//

import Foundation

class Song {
    
    var id: Int
    var name: String
    var numberOfLikes: Int
    var numberOfPlays: Int
    
    //String because incoming info is in String
    init? (id: String, name: String, numberOfLikes: String, numberOfPlays: String) {
        self.id = Int(id)!
        self.name = name
        self.numberOfLikes = Int(numberOfLikes) ?? 404
        self.numberOfPlays = Int(numberOfPlays) ?? 404
    }
    
    func getId() -> Int {
        return id
    }
    
    func getName() -> String {
        return name
    }
    
    func getNumberOfLikes() -> Int {
        return numberOfLikes
    }
    
    func getNumberOfPlays() -> Int {
        return numberOfPlays
    }
    
}
