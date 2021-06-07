//
//  Bomberman.swift
//  Kaboom
//
//  Created by Alumne on 13/5/21.
//

import Foundation
import SpriteKit

class Bomberman: SKSpriteNode {

    private let player: Player
    private let bombManager: BombManager
    private let bomb: Bomb

    private var moveDuration: Double = 2
    public var desiredPosition: CGPoint
    public var round: Int = 1
    private let startRoundTimer: Double = 1.5
    private var roundFinished: Bool = false

    private var bombDropInterval: Double
    private var bombsToDrop: Int = 10
    private var bombsDropped: Int = 0

    private let bombYOffset: Int = -40

    init(player: Player, bombManager: BombManager) {

        self.player = player
        self.bombManager = bombManager
        bomb = Bomb(inititalPosition: CGPoint(x: 0, y: bombYOffset), initializePhysics: false, round: round)
        bomb.isHidden = true

        desiredPosition = CGPoint(x: 0, y: GameConfiguration.gameHeight / 2  - 300)
        bombDropInterval = 1

        super.init(texture: SKTexture(imageNamed: "bomberman"), color: .clear, size: CGSize(width: 60, height: 116))

        position = desiredPosition

        run(SKAction.wait(forDuration: startRoundTimer), completion: startRound)

        addChild(bomb)

        if difficulty != Difficulty.easy {
            for _ in 2...difficulty.values().index {
                forceLevelUp()
                forceLevelUp()
            }
        }
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

        bombManager.createBomb(initialPosition: CGPoint(x: position.x, y: position.y + CGFloat(bombYOffset)),
                               roundNumber: round)
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

        round += 1
        forceLevelUp()
        bombsDropped = 0
    }

    private func forceLevelUp() {
        moveDuration *= 0.75
        bombDropInterval *= 0.75
        bombsToDrop = (Int)(Double(bombsToDrop) * 1.5)
    }

    public func bombOnEnd(bomb: Bomb) -> Bool {

        if bomb.isRedBomb {
            bombManager.removeFriendlyBomb(bomb: bomb)
            return false
        }

        removeAllActions()
        roundFinished = false
        guard let explosionAnimationDuration = bombManager.bombs.first?.explosion.getAnimationDuration()
            else {return false}
        let duration = explosionAnimationDuration * Double(bombManager.bombs.count + 2)
        run(SKAction.wait(forDuration: duration), completion: startRound)

        bombManager.freezeBombs()
        return player.loseLive()
    }
}

class BombManager: SKNode {

    public var bombs: [Bomb] = []
    private let bombEndCollider: SKSpriteNode

    override init() {

        bombEndCollider = SKSpriteNode(color: UIColor.green,
                                       size: CGSize(width: GameConfiguration.gameWidth, height: 30))
        bombEndCollider.name = "BombEndCollider"
        bombEndCollider.position = CGPoint(x: 0, y: -GameConfiguration.gameHeight / 2 + 30)
        bombEndCollider.physicsBody = SKPhysicsBody(rectangleOf: bombEndCollider.size)
        bombEndCollider.physicsBody?.affectedByGravity = false
        bombEndCollider.physicsBody?.isDynamic = false
        bombEndCollider.physicsBody?.categoryBitMask = CategoryBitMasks.bombEndBitMask
        bombEndCollider.physicsBody?.collisionBitMask = CategoryBitMasks.bombBitMask
        bombEndCollider.physicsBody?.contactTestBitMask = bombEndCollider.physicsBody!.collisionBitMask

        super.init()

        addChild(bombEndCollider)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func createBomb(initialPosition: CGPoint, roundNumber: Int) {

        let newBomb = Bomb(inititalPosition: initialPosition, initializePhysics: true, round: roundNumber)
        newBomb.name = "Bomb"
        bombs.append(newBomb)
        addChild(newBomb)
    }

    public func freezeBombs() {

        for bomb in bombs {
            bomb.freezeBomb()
        }
        bombOnEnd()
    }

    private func bombOnEnd() {

        guard let firstBomb = bombs.first else {return}

        firstBomb.explode()
        run(SKAction.wait(forDuration: firstBomb.explosion.getAnimationDuration()), completion: bombOnEnd)
        bombs.removeFirst()
    }

    public func stopBomb(bomb: Bomb) {

        var index = -1
        for number in 0...(bombs.count - 1) where bombs[number] == bomb {
            index = number
        }

        if index == -1 {
            return
        }

        bomb.stopBomb()
        bombs.remove(at: index)
    }

    public func removeFriendlyBomb(bomb: Bomb) {
        var index = -1
        for number in 0...(bombs.count - 1) where bombs[number] == bomb {
            index = number
        }

        if index == -1 {
            return
        }

        bombs.remove(at: index)
        bomb.explode()
    }

    public func getExplodingAnimationDuration() -> Double {
        guard let firstBomb = bombs.first else {return 0}

        return firstBomb.explosion.getAnimationDuration() * Double(bombs.count)
    }
}

class Bomb: SKSpriteNode {

    public var exploded: Bool = false
    public var round: Int
    public var explosion: BombExplosion
    public var isRedBomb: Bool

    init(inititalPosition: CGPoint, initializePhysics: Bool, round: Int) {
        self.round = round
        self.explosion = BombExplosion()

        let randomNumber = Int.random(in: 0...100)
        isRedBomb = randomNumber < 5 && initializePhysics

        super.init(texture: SKTexture(imageNamed: isRedBomb ? "friendlybomb0" : "bomb0"),
                   color: .clear, size: CGSize(width: 35, height: 56))

        position = inititalPosition

        if initializePhysics {
            physicsBody = SKPhysicsBody(texture: texture!, size: size)
            physicsBody?.categoryBitMask = CategoryBitMasks.bombBitMask
            physicsBody?.collisionBitMask = CategoryBitMasks.playerBitMask | CategoryBitMasks.bombEndBitMask
            physicsBody?.contactTestBitMask = physicsBody!.collisionBitMask

            let bombAnimation = [SKTexture(imageNamed: isRedBomb ? "friendlybomb2" : "bomb2"),
                                 SKTexture(imageNamed: isRedBomb ? "friendlybomb3" : "bomb3")]
            run(SKAction.repeatForever(SKAction.animate(with: bombAnimation, timePerFrame: 0.3)))
        }

        xScale *= randomNumber < 50 ? 1 : -1
        addChild(explosion)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func explode() {
        if exploded {return}

        exploded = true

        removeAllActions()
        physicsBody = nil
        texture = nil

        run(SKAction.wait(forDuration: explosion.getAnimationDuration()), completion: removeFromParent)
        explosion.playExplosion()
    }

    public func freezeBomb() {
        removeAllActions()
        physicsBody = nil
    }

    public func stopBomb() {
        if exploded {return}
        exploded = true

        removeFromParent()
    }
}

class BombExplosion: SKSpriteNode {

    private let frameDuration: Double = 0.1
    private let explodeAnimation: [SKTexture] =
        [SKTexture(imageNamed: "bombExplosion0"), SKTexture(imageNamed: "bombExplosion1"),
        SKTexture(imageNamed: "bombExplosion2")]

    init() {
        super.init(texture: SKTexture(imageNamed: "bombExplosion0"), color: .clear, size: CGSize(width: 56, height: 53))
        isHidden = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func getAnimationDuration() -> Double {
        return Double(explodeAnimation.count) * frameDuration
    }

    public func playExplosion() {
        isHidden = false
        run(SKAction.animate(with: explodeAnimation, timePerFrame: frameDuration))
    }
}
