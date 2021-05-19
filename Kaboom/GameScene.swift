//
//  GameScene.swift
//  Kaboom
//
//  Created by Alumne on 15/4/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    private var player: Player = Player()
    private var bombManager: BombManager = BombManager()
    private var bomberman: Bomberman!

    override func didMove(to view: SKView) {

        bomberman = Bomberman(bombManager: bombManager)
        
        addChild(player)
        addChild(bombManager)
        addChild(bomberman)
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

        for touch in touches {
            if touch == player.movingTouch {
                player.moveTouch(desiredPos: touch.location(in: self))
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
