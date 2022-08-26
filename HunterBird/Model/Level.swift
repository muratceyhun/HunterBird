//
//  Level.swift
//  HunterBird
//
//  Created by Murat Ceyhun Korpeoglu on 16.08.2022.
//

import Foundation



struct Level {
    
    
    let birds : [String]
    
    init?(level : Int) {
        guard let levelsDictionary = Levels.levelsDictionary["Level\(level)"] as? [String : Any] else {return nil}
        
        guard let birds = levelsDictionary["Birds"] as? [String] else {return nil}
        
        
        self.birds = birds
    }
    
    
    
}
