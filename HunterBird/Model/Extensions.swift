//
//  Extensions.swift
//  HunterBird
//
//  Created by Murat Ceyhun Korpeoglu on 9.08.2022.
//

import Foundation
import CoreGraphics
import SpriteKit


extension CGPoint {
    
    static public func +(left : CGPoint, right : CGPoint) -> CGPoint {
        return CGPoint(x: left.x+right.x, y: left.y+right.y)
    }
    static public func -(left : CGPoint, right : CGPoint) -> CGPoint {
        return CGPoint(x: left.x-right.x, y: left.y-right.y)
    }
    static public func *(left : CGPoint, right : CGFloat) -> CGPoint {
        return CGPoint(x: left.x*right, y: left.y*right)
    }
}


extension SKNode {
    
    func scale(size : CGSize, width : Bool, rate : CGFloat) {
        
        let scale = width ? (size.width * rate) / self.frame.size.width : (size.height*rate) / (self.frame.size.height)
        self.setScale(scale)
        
    }
    
}
