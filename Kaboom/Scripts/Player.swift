//
//  Player.swift
//  Kaboom
//
//  Created by Alumne on 11/5/21.
//

import Foundation
import SpriteKit

class Player: SKNode {

    private let score: Score

    public var lives: [WoodenPanel]
    private let maximumLives: Int = 3

    private let moveDuration: Double = 0.2
    public var movingTouch: UITouch?
    public var desiredPosition: CGPoint

    private var losingLive: Bool

    init(score: Score) {

        self.score = score

        lives = [WoodenPanel]()

        desiredPosition = CGPoint(x: 0, y: -GameConfiguration.gameHeight / 2 + 100)
        losingLive = false

        super.init()

        for number in 0...(maximumLives - 1) {
            lives.append(WoodenPanel(playerReference: self, numberOnPlayer: number, image: "player"))
            addChild(lives[number])
        }

        position = desiredPosition
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func initializeTouch(touch: UITouch, desiredPos: CGPoint) {

        movingTouch = touch
        desiredPosition = desiredPos
        runMoveAction(node: self, desiredPosition: desiredPosition, movementSpeed: moveDuration)
    }

    public func moveTouch(desiredPos: CGPoint) {

        desiredPosition = desiredPos
        runMoveAction(node: self, desiredPosition: desiredPosition, movementSpeed: moveDuration)
    }

    public func loseLive() {

        if losingLive || lives.count == 0 {
            return
        }
        losingLive = true
        lives.last?.removeFromParent()
    }

    public func stopBomb(live: WoodenPanel, bomb: Bomb) {

        live.playWaterSplash()
        bomb.explode()
        score.addScore(scoreToAdd: 10)
    }
}

class WoodenPanel: SKSpriteNode {

    private var player: Player

    init(playerReference: Player, numberOnPlayer: Int, image: String) {

        player = playerReference

        let texture = SKTexture(imageNamed: image)

        super.init(texture: texture, color: .clear, size: CGSize(width: 98, height: 28))
        self.position = CGPoint(x: 0, y: 0 + numberOnPlayer * 45)

        if numberOnPlayer > 0 {
            return
        }
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CategoryBitMasks.playerBitMask
        physicsBody?.collisionBitMask = CategoryBitMasks.bombBitMask
        physicsBody?.contactTestBitMask = physicsBody!.collisionBitMask
    }

    public func playWaterSplash() {

        removeAllActions()
        // PLAY WATER SPLASH ANIMATION
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
