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

    init(score: Score, isHardMode: Bool) {

        self.score = score

        lives = [WoodenPanel]()

        desiredPosition = CGPoint(x: 0, y: -GameConfiguration.gameHeight / 2 + 100)
        losingLive = false

        super.init()

        for number in 0...(maximumLives - 1) {
            lives.append(WoodenPanel(playerReference: self, numberOnPlayer: number, image: "woodenPlank"))
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

    public func removeTouch() {

        movingTouch = nil
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

        if bomb.exploded {return}

        live.playWaterSplash()
        bomb.explode()
        score.addScore(scoreToAdd: bombValue * bomb.round)
    }
}

class WoodenPanel: SKSpriteNode {

    private var player: Player
    private let splashAnimation: [SKTexture]

    init(playerReference: Player, numberOnPlayer: Int, image: String) {

        player = playerReference

        let texture = SKTexture(imageNamed: image)

        splashAnimation = [SKTexture(imageNamed: "splash0"), SKTexture(imageNamed: "splash1"),
                           SKTexture(imageNamed: "splash2"), SKTexture(imageNamed: image)]

        super.init(texture: texture, color: .clear, size: CGSize(width: 98, height: 53))
        self.position = CGPoint(x: 0, y: 0 + numberOnPlayer * 45)

        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width, height: size.height / 2),
                                    center: CGPoint(x: 0, y: -size.height / 5))
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CategoryBitMasks.playerBitMask
        physicsBody?.collisionBitMask = CategoryBitMasks.bombBitMask
        physicsBody?.contactTestBitMask = physicsBody!.collisionBitMask
    }

    public func playWaterSplash() {

        removeAllActions()
        run(SKAction.animate(with: splashAnimation, timePerFrame: 0.1))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
