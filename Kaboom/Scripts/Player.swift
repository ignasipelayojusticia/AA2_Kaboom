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

    public var losingLive: Bool

    init(score: Score, isHardMode: Bool) {

        self.score = score

        lives = [WoodenPanel]()

        desiredPosition = CGPoint(x: 0, y: -GameConfiguration.gameHeight / 2 + 100)
        losingLive = false

        super.init()

        for number in 0...(maximumLives - 1) {
            lives.append(WoodenPanel(playerReference: self, numberOnPlayer: number))
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

        if lives.count == 0 {
            return
        }

        losingLive = true
        let firstLive = lives.first
        lives.removeFirst()
        firstLive?.removeFromParent()

        if lives.count <= 0 {
            print("GAME OVER")
        }
    }

    public func stopBomb(live: WoodenPanel, round: Int, isFriendlyBomb: Bool) {

        live.playWaterSplash()

        if isFriendlyBomb {
            score.substractScore(scoreToSubstract: 500)
            print("RED BOMB")
            return
        }

        if score.addScore(scoreToAdd: bombValue * round) {
            oneUp()
        }
    }

    private func oneUp() {
        if lives.count == maximumLives {
            print("MAX LIVES")
            return
        }

        let number = maximumLives - 1 - lives.count
        lives.insert(WoodenPanel(playerReference: self, numberOnPlayer: number), at: 0)
        addChild(lives[0])
    }
}

class WoodenPanel: SKSpriteNode {

    private var player: Player
    private let splashAnimation: [SKTexture]

    init(playerReference: Player, numberOnPlayer: Int) {

        player = playerReference

        let currentLevel = "level" + String(currentWoodenPlankLevel)
        let texture = SKTexture(imageNamed: "plank_0_" + currentLevel)

        splashAnimation = [SKTexture(imageNamed: "plank_1_" + currentLevel),
                           SKTexture(imageNamed: "plank_2_" + currentLevel),
                           SKTexture(imageNamed: "plank_3_" + currentLevel),
                           SKTexture(imageNamed: "plank_0_" + currentLevel)]

        super.init(texture: texture, color: .clear, size: CGSize(width: 147, height: 53))
        self.position = CGPoint(x: 0, y: 0 + numberOnPlayer * 45)

        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 49 * currentWoodenPlankLevel, height: Int(size.height) / 2),
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
