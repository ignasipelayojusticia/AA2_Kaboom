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

        player = Player(score: score, isHardMode: false)
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

        for touch in touches where touch == player.movingTouch {
            player.removeTouch()
        }
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
        } else {
            if !collisionPlayerBomb(nodeA: nodeA, nodeB: nodeB) {
                collisionPlayerBomb(nodeA: nodeB, nodeB: nodeA)
            }
        }
    }

    private func collisionPlayerBomb(nodeA: SKNode, nodeB: SKNode) -> Bool {

        guard let liveNode = nodeA as? WoodenPanel else {return false}
        guard let bombNode = nodeB as? Bomb else {return false}

        if bombNode.exploded {
            return true
        }

        player.stopBomb(live: liveNode, round: bombNode.round)
        bombManager.stopBomb(bomb: bombNode)
        return true
    }
}
