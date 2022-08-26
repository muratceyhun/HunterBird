//
//  GameCamera.swift
//  HunterBird
//
//  Created by Murat Ceyhun Korpeoglu on 8.08.2022.
//

import UIKit
import SpriteKit

class GameCamera: SKCameraNode {
    
    
    func determineBorders(scene : SKScene, frame : CGRect, node : SKNode?) {
        let scaledDimension = CGSize(width: scene.size.width*xScale, height: scene.size.height*yScale)
        let borderFrame = frame
        let xOutside = min(scaledDimension.width/2, borderFrame.width/2)
        let yOutside = min(scaledDimension.height/2, borderFrame.height/2)
        let cameraFrame = borderFrame.insetBy(dx: xOutside, dy: yOutside)
        let cameraXRange = SKRange(lowerLimit: cameraFrame.minX, upperLimit: cameraFrame.maxX)
        let cameraYRange = SKRange(lowerLimit: cameraFrame.minY, upperLimit: cameraFrame.maxY)
        let sideConstraint = SKConstraint.positionX(cameraXRange, y: cameraYRange)
        
        if let node = node {
            let zero = SKRange(constantValue: 0)
            let locationConstraint = SKConstraint.distance(zero, to: node)
            constraints = [locationConstraint,sideConstraint]
        } else {
            constraints = [sideConstraint]
        }
      
    }

}
