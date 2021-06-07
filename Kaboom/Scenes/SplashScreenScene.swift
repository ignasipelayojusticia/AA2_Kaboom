//
//  MainMenuScene.swift
//  Kaboom
//
//  Created by Alumne on 6/6/21.
//

import SpriteKit
import GameplayKit

class SplashScreenScene: Scene {

    override func didMove(to view: SKView) {

        backgroundColor = SKColor(red: 0.2, green: 0.4, blue: 0.22, alpha: 1)

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

        let bomb = SKSpriteNode(imageNamed: "bomb_splashscreen")
        bomb.position = CGPoint(x: GameConfiguration.gameWidth / 3, y: GameConfiguration.gameHeight / 10)
        addChild(bomb)

        let redBomb = SKSpriteNode(imageNamed: "redbomb_splashscreen")
        redBomb.position = CGPoint(x: -GameConfiguration.gameWidth / 4, y: -GameConfiguration.gameHeight / 7)
        addChild(redBomb)

        let woodenPlank = SKSpriteNode(imageNamed: "woodenplank_splashscreen")
        woodenPlank.position = CGPoint(x: GameConfiguration.gameWidth / 10, y: -GameConfiguration.gameHeight / 3)
        addChild(woodenPlank)

        run(SKAction.wait(forDuration: 3), completion: loadMainMenu)
    }

    private func loadMainMenu() {
        gameViewController.loadScene(sceneName: "MainMenu")
    }
}
