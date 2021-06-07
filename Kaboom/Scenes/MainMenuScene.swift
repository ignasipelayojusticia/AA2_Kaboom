//
//  MainMenuScene.swift
//  Kaboom
//
//  Created by Alumne on 6/6/21.
//

import SpriteKit
import GameplayKit

class MainMenuScene: Scene {

    private let kaboomTitle: SKLabelNode = SKLabelNode()

    override func didMove(to view: SKView) {
        
        kaboomTitle.position = CGPoint(x: 0, y: -GameConfiguration.gameHeight / 3)
        kaboomTitle.text = "Kaboom!"
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameViewController.loadScene(sceneName: "Game")
    }
}
