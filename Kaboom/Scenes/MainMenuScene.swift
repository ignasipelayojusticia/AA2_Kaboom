//
//  MainMenuScene.swift
//  Kaboom
//
//  Created by Alumne on 7/6/21.
//

import SpriteKit
import GameplayKit

class MainMenuScene: Scene {

    override func didMove(to view: SKView) {

        backgroundColor = SKColor(red: 0.16, green: 0.39, blue: 0.47, alpha: 1)

        let kaboomTitle = SKLabelNode()
        kaboomTitle.fontName = "SlapAndCrumbly"
        kaboomTitle.fontSize *= 3.5
        kaboomTitle.fontColor = SKColor.black
        kaboomTitle.position = CGPoint(x: 0, y: GameConfiguration.gameHeight / 3)
        kaboomTitle.text = "KABOOM!"
        addChild(kaboomTitle)

        let madeBySubtitle = SKLabelNode()
        madeBySubtitle.fontName = "SlapAndCrumbly"
        madeBySubtitle.fontColor = SKColor.black
        madeBySubtitle.position = CGPoint(x: kaboomTitle.position.x, y: kaboomTitle.position.y - 80)
        madeBySubtitle.text = "BY IGNASI PELAYO"
        addChild(madeBySubtitle)

        let easyButton = SKSpriteNode(imageNamed: "easy")
        easyButton.position = CGPoint(x: 0, y: -GameConfiguration.gameHeight * 0.1)
        easyButton.name = "easyButton"
        addChild(easyButton)

        let mediumButton = SKSpriteNode(imageNamed: "medium")
        mediumButton.position = CGPoint(x: 0, y: -GameConfiguration.gameHeight * 0.25)
        mediumButton.name = "mediumButton"
        addChild(mediumButton)

        let hardButton = SKSpriteNode(imageNamed: "hard")
        hardButton.position = CGPoint(x: 0, y: -GameConfiguration.gameHeight * 0.4)
        hardButton.name = "hardButton"
        addChild(hardButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {

            let location = touch.location(in: self)
            let nodesarray = nodes(at: location)

            for node in nodesarray {
                switch node.name {
                case "easyButton":
                    difficulty = Difficulty.easy
                    loadGame()

                case "mediumButton":
                    difficulty = Difficulty.medium
                    loadGame()

                case "hardButton":
                    difficulty = Difficulty.hard
                    loadGame()

                default:
                    break
                }
            }
        }
    }

    private func loadGame() {
        gameViewController.loadScene(sceneName: "Game")
    }
}
