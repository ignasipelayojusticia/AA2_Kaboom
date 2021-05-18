//
//  MovingSprite.swift
//  Kaboom
//
//  Created by Alumne on 18/5/21.
//

import Foundation
import SpriteKit

public func runMoveAction(node: SKNode, desiredPosition: CGPoint, movementSpeed: Double, callback: @escaping () -> Void) {

    let widthFactor = Double(abs(node.position.x - desiredPosition.x) / GameConfiguration.gameWidth)
    let moveAction = SKAction.moveTo(x: desiredPosition.x, duration: Double(movementSpeed * widthFactor))
    node.run(moveAction, completion: callback)
}

public func runMoveAction(node: SKNode, desiredPosition: CGPoint, movementSpeed: Double) {

    let widthFactor = Double(abs(node.position.x - desiredPosition.x) / GameConfiguration.gameWidth)
    let moveAction = SKAction.moveTo(x: desiredPosition.x, duration: Double(movementSpeed * widthFactor))
    moveAction.timingMode = SKActionTimingMode.easeInEaseOut
    node.run(moveAction)
}
