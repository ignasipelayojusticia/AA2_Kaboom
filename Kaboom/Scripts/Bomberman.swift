//
//  Bomberman.swift
//  Kaboom
//
//  Created by Alumne on 13/5/21.
//

import Foundation
import SpriteKit

class Bomberman: SKSpriteNode {

    private let bombManager: BombManager
    private let bomb: Bomb

    private var moveDuration: Double = 2
    public var desiredPosition: CGPoint
    private let startRoundTimer: Double = 1.5
    private var roundFinished: Bool = false

    private var bombDropInterval: Double
    private var bombsToDrop: Int = 10
    private var bombsDropped: Int = 0

    private let bombYOffset: Int = -40

    init(bombManager: BombManager) {

        self.bombManager = bombManager
        bomb = Bomb(inititalPosition: CGPoint(x: 0, y: bombYOffset), initializePhysics: false)
        bomb.isHidden = true

        desiredPosition = CGPoint(x: 0, y: GameConfiguration.gameHeight / 2  - 300)
        bombDropInterval = 1

        super.init(texture: SKTexture(imageNamed: "bomberman"), color: .clear, size: CGSize(width: 60, height: 116))

        position = desiredPosition

        run(SKAction.wait(forDuration: startRoundTimer), completion: startRound)

        addChild(bomb)
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
        
        bomb.isHidden = false
        roundFinished = false
        keepMoving()
        waitToDropBomb()
    }

    private func waitToDropBomb() {

        run(SKAction.wait(forDuration: bombDropInterval), completion: dropBomb)
    }

    private func dropBomb() {

        bombManager.createBomb(initialPosition: CGPoint(x: position.x, y: position.y + CGFloat(bombYOffset)))
        bombsDropped += 1
        if bombsDropped <= bombsToDrop {
            waitToDropBomb()
        } else {
            bomb.isHidden = true
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

class BombManager : SKNode {

    public var bombs: [Bomb] = []

    override init() {
 
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func createBomb(initialPosition: CGPoint) {
 
        let newBomb = Bomb(inititalPosition: initialPosition, initializePhysics: true)
        bombs.append(newBomb)
        addChild(newBomb)
    }
}

class Bomb: SKSpriteNode {

    init(inititalPosition: CGPoint, initializePhysics: Bool) {

        super.init(texture: SKTexture(imageNamed: "bomb_3"), color: .clear, size: CGSize(width: 40, height: 45))

        position = inititalPosition

        if initializePhysics {
            physicsBody = SKPhysicsBody(texture: texture!, size: size)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
