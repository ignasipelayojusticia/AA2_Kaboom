//
//  GameScene.swift
//  Kaboom
//
//  Created by Alumne on 15/4/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    private var player: Player!
    private var bombManager: BombManager = BombManager()
    private var bomberman: Bomberman!
    private var score: Score = Score()

    override func didMove(to view: SKView) {

        player = Player(score: score)
        bomberman = Bomberman(player: player, bombManager: bombManager)

        addChild(player)
        addChild(bombManager)
        addChild(bomberman)
        addChild(score)

        physicsWorld.contactDelegate = self
    }

    func touchDown(atPoint pos: CGPoint) {

    }

    func touchMoved(toPoint pos: CGPoint) {

    }

    func touchUp(atPoint pos: CGPoint) {

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if let touch = touches.first {

            player.initializeTouch(touch: touch, desiredPos: touch.location(in: self))
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch in touches where touch == player.movingTouch {
            player.moveTouch(desiredPos: touch.location(in: self))
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

    func didBegin(_ contact: SKPhysicsContact) {

        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}

        if nodeA.name == "BombEndCollider" || nodeB.name == "BombEndCollider" {
            bomberman.bombOnEnd()
        } else if nodeA is Bomb {
            player.stopBomb(live: (nodeB as? WoodenPanel)!, bomb: (nodeA as? Bomb)!)
        } else if nodeB is Bomb {
            player.stopBomb(live: (nodeA as? WoodenPanel)!, bomb: (nodeB as? Bomb)!)
        }
    }
}
