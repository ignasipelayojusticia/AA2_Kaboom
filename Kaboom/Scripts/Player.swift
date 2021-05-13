//
//  Player.swift
//  Kaboom
//
//  Created by Alumne on 11/5/21.
//

import Foundation
import SpriteKit

class Player: SKNode {

    public var lives: [WoodenPanel]
    private let maximumLives: Int = 3

    private let moveDuration: Double = 0.2
    public var movingTouch: UITouch?
    public var desiredPosition: CGPoint

    override init() {

        lives = [WoodenPanel]()

        desiredPosition = CGPoint(x: 0, y: -GameConfiguration.gameHeight / 2 + 200)

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
        runMoveAction()
    }

    public func moveTouch(desiredPos: CGPoint) {

        desiredPosition = desiredPos
        runMoveAction()
    }

    private func runMoveAction() {

        let widthFactor = Double(abs(position.x - desiredPosition.x) / GameConfiguration.gameWidth)
        let moveAction = SKAction.moveTo(x: desiredPosition.x, duration: Double(moveDuration * widthFactor))
        moveAction.timingMode = SKActionTimingMode.easeInEaseOut
        run(moveAction)
    }
}

class WoodenPanel: SKSpriteNode {

    private var player: Player

    init(playerReference: Player, numberOnPlayer: Int, image: String) {

        player = playerReference

        let texture = SKTexture(imageNamed: image)

        super.init(texture: texture, color: .clear, size: CGSize(width: 98, height: 28))
        self.position = CGPoint(x: 0, y: 0 + numberOnPlayer * 45)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
