//
//  GameScene.swift
//  Kaboom
//
//  Created by Alumne on 15/4/21.
//

import SpriteKit
import GameplayKit

class GameScene: Scene, SKPhysicsContactDelegate {

    private var player: Player!
    private var bombManager: BombManager = BombManager()
    private var bomberman: Bomberman!
    private var score: Score = Score()

    override func didMove(to view: SKView) {

        backgroundColor = SKColor(red: 0.14, green: 0.14, blue: 0.14, alpha: 1)

        player = Player(score: score, isHardMode: false)
        bomberman = Bomberman(player: player, bombManager: bombManager)

        addChild(player)
        addChild(bombManager)
        addChild(bomberman)
        addChild(score)

        physicsWorld.contactDelegate = self
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

    func didBegin(_ contact: SKPhysicsContact) {

        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}

        if nodeA.name == "BombEndCollider" {
            guard let bombNode = nodeB as? Bomb else {return}
            if bomberman.bombOnEnd(bomb: bombNode) {
                run(SKAction.wait(forDuration: bombManager.getExplodingAnimationDuration()),
                    completion: loadMainMenuScene)
            }
        } else if nodeB.name == "BombEndCollider" {
            guard let bombNode = nodeA as? Bomb else {return}
            if bomberman.bombOnEnd(bomb: bombNode) {
                run(SKAction.wait(forDuration: bombManager.getExplodingAnimationDuration()),
                    completion: loadMainMenuScene)
            }
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

        player.stopBomb(live: liveNode, round: bombNode.round, isFriendlyBomb: bombNode.isRedBomb)
        bombManager.stopBomb(bomb: bombNode)
        return true
    }

    private func loadMainMenuScene() {
        gameViewController.loadScene(sceneName: "MainMenu")
    }
}
