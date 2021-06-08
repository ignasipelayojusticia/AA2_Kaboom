//
//  HighScoresScene.swift
//  Kaboom
//
//  Created by Alumne on 8/6/21.
//

import SpriteKit
import GameplayKit

class HighScoresScene: Scene {

    private var highScores: [HighScore] = [
        HighScore(classification: 1, difficulty: "Easy", score: 1500),
        HighScore(classification: 2, difficulty: "Hard", score: 1000),
        HighScore(classification: 3, difficulty: "Medium", score: 500)
    ]

    override func didMove(to view: SKView) {

        backgroundColor = SKColor(red: 0.16, green: 0.39, blue: 0.47, alpha: 1)

        let highScoresTitle1 = SKLabelNode()
        highScoresTitle1.fontName = "SlapAndCrumbly"
        highScoresTitle1.fontSize *= 5
        highScoresTitle1.fontColor = SKColor.black
        highScoresTitle1.position = CGPoint(x: 0, y: GameConfiguration.gameHeight / 3)
        highScoresTitle1.text = "HIGH"
        addChild(highScoresTitle1)

        let highScoresTitle2 = SKLabelNode()
        highScoresTitle2.fontName = "SlapAndCrumbly"
        highScoresTitle2.fontSize *= 5
        highScoresTitle2.fontColor = SKColor.black
        highScoresTitle2.position = CGPoint(x: 0, y: GameConfiguration.gameHeight / 5)
        highScoresTitle2.text = "SCORES"
        addChild(highScoresTitle2)

        for index in 0...(highScores.count - 1) {
            highScores[index].position = CGPoint(x: 0, y: index * -60)
            addChild(highScores[index])
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        loadMainMenu()
    }

    private func loadMainMenu() {
        gameViewController.loadScene(sceneName: "MainMenu")
    }
}

class HighScore: SKNode {

    private var classification: SKSpriteNode!
    private var difficulty: SKLabelNode!
    private var score: SKLabelNode!

    init(classification: Int, difficulty: String, score: Int) {
        self.classification = SKSpriteNode(texture: SKTexture(imageNamed: "classification_" + String(classification)),
                                           size: CGSize(width: 30, height: 30))
        self.classification.position = CGPoint(x: -60, y: 0)

        self.difficulty = SKLabelNode()
        self.difficulty.fontName = "SlapAndCrumbly"
        self.difficulty.text = difficulty
        self.difficulty.position = CGPoint(x: -30, y: 0)

        self.score = SKLabelNode()
        self.score.fontName = "SlapAndCrumbly"
        self.score.text = String(score)
        self.score.position = CGPoint(x: 50, y: 0)

        super.init()

        addChild(self.classification)
        addChild(self.difficulty)
        addChild(self.score)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
