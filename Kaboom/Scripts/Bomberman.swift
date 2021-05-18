//
//  Bomberman.swift
//  Kaboom
//
//  Created by Alumne on 13/5/21.
//

import Foundation
import SpriteKit

class Bomberman: SKSpriteNode {
    
    private let bomb: Bomb
    
    private var moveDuration: Double = 2
    public var desiredPosition: CGPoint
    private let startRoundTimer: Double = 1.5
    private var roundFinished: Bool = false
    
    private var bombDropInterval: Double
    private var bombsToDrop: Int = 10
    private var bombsDropped: Int = 0
    
    private let bombYOffset: Int = -40

    init() {

        desiredPosition = CGPoint(x: 0, y: GameConfiguration.gameHeight / 2  - 300)
        bomb = Bomb(inititalPosition: CGPoint(x: 0, y: 0))
        bombDropInterval = 1

        super.init(texture: SKTexture(imageNamed: "bomberman"), color: .clear, size: CGSize(width: 60, height: 116))

        position = desiredPosition

        self.addChild(bomb)
        
        run(SKAction.wait(forDuration: startRoundTimer), completion: startRound)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func keepMoving() {
        
        if roundFinished {
            runMoveAction(node: self, desiredPosition: CGPoint(x: 0, y: position.y), movementSpeed: moveDuration)
            return
        }
        
        desiredPosition = CGPoint(x: CGFloat.random(in: -0.5...0.5) * GameConfiguration.gameWidth, y: position.y)
        runMoveAction(node: self, desiredPosition: desiredPosition, movementSpeed: moveDuration, callback: keepMoving)
    }

    private func startRound() {
 
        if roundFinished {
            levelUp()
        }

        roundFinished = false
        keepMoving()
        waitToDropBomb()
    }
    
    private func waitToDropBomb() {
        
        run(SKAction.wait(forDuration: bombDropInterval), completion: dropBomb)
    }
    
    private func dropBomb() {
        
        bomb.position = CGPoint(x: 0, y: bombYOffset)
        bombsDropped += 1
        if bombsDropped <= bombsToDrop {
            waitToDropBomb()
        }
        else {
            roundFinished = true
            run(SKAction.wait(forDuration: startRoundTimer), completion: startRound)
        }
    }
    
    private func levelUp() {
        
        moveDuration *= 0.75
        bombDropInterval *= 0.8
        bombsToDrop = (Int)(Double(bombsToDrop) * 1.5)
        bombsDropped = 0
    }
}

class Bomb: SKSpriteNode {
    
    init(inititalPosition: CGPoint) {

        super.init(texture: SKTexture(imageNamed: "bomb_3"), color: .clear, size: CGSize(width: 40, height: 45))
        
        position = inititalPosition
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
