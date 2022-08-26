//
//  Settings.swift
//  HunterBird
//
//  Created by Murat Ceyhun Korpeoglu on 10.08.2022.
//

import Foundation
import UIKit

struct ZPozition {
    static let background : CGFloat = 0
    static let obstacle : CGFloat = 1
    static let bird : CGFloat = 3
    static let offGameBackGround : CGFloat = 10
    static let labelMenu : CGFloat = 11
}

struct PhysicsCategories {
    
    static let empty : UInt32 = 0
    static let gold : UInt32 = 0
    static let all : UInt32 = .max
    static let side : UInt32 = 0x1
    static let bird : UInt32 = 0x1 << 1
    static let block : UInt32 = 0x1 << 2
    static let enemy : UInt32 = 0x1 << 3
}


enum GameSituation {
    
    case Ready
    case Flying
    case Finish
    case Resurrection
    case GameOver
}



struct Levels {
    static var levelsDictionary = [String:Any]()
}
