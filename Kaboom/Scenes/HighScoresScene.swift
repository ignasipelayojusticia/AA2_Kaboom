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
        HighScore(classification: 1, difficulty: Difficulty.easy, score: 1500),
        HighScore(classification: 2, difficulty: Difficulty.hard, score: 1000),
        HighScore(classification: 3, difficulty: Difficulty.medium, score: 500)
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

        let yourScore = SKLabelNode()
        yourScore.fontName = "SlapAndCrumbly"
        yourScore.fontSize *= 3
        yourScore.text = String(finalRoundScore)
        addChild(yourScore)

        initializeScores()

        let tapToContinue = SKLabelNode()
        tapToContinue.fontName = "SlapAndCrumbly"
        tapToContinue.fontColor = SKColor.white
        tapToContinue.position = CGPoint(x: 0, y: -GameConfiguration.gameHeight * 0.5)
        tapToContinue.text = "tap to continue"
        addChild(tapToContinue)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        loadMainMenu()
    }

    private func loadMainMenu() {
        gameViewController.loadScene(sceneName: "MainMenu")
    }

    private func initializeScores() {
        clearHighScore()

        createData(dataName: "highScores")
        orderDataWithNewValue()
        saveNewHighScores()
        for index in 0...(highScores.count - 1) {
            highScores[index].position = CGPoint(x: 80,
                                                 y: GameConfiguration.gameHeight * -0.15 +
                                                    CGFloat(index) * -GameConfiguration.gameHeight * 0.12)
            addChild(highScores[index])
        }
    }

    private func createData(dataName: String) {
        // Load Data or create empty data if not created
        guard let data = UserDefaults.standard.value(forKey: dataName) as? Data else {
            do {
                let emptyData = try JSONEncoder().encode([
                    HighScoreData(difficulty: Difficulty.empty, score: 0),
                    HighScoreData(difficulty: Difficulty.empty, score: 0),
                    HighScoreData(difficulty: Difficulty.empty, score: 0)
                ])
                UserDefaults.standard.setValue(emptyData, forKey: dataName)
                initializeScores()
            } catch {
                print(error)
            }
            return
        }

        // Decode the data
        do {
            let highScoresData = try JSONDecoder().decode([HighScoreData].self, from: data)
            for number in 0...(highScoresData.count - 1) {
                highScores.append(HighScore(classification: highScoresData[number].difficulty != Difficulty.empty ?
                                                number + 1 : 0,
                                            difficulty: highScoresData[number].difficulty,
                                            score: highScoresData[number].score))
            }
        } catch {
            print(error)
        }
    }

    private func orderDataWithNewValue() {
        if finalRoundScore > highScores[0].scoreValue {
            let newSecondScore = HighScoreData(difficulty: highScores[0].difficultyValue,
                                               score: highScores[0].scoreValue)
            let newThirdScore = HighScoreData(difficulty: highScores[1].difficultyValue,
                                              score: highScores[1].scoreValue)
            clearHighScore()
            highScores.append(HighScore(classification: 1, difficulty: difficulty, score: finalRoundScore))
            highScores.append(HighScore(classification: newSecondScore.difficulty != Difficulty.empty ? 2 : 0,
                                        difficulty: newSecondScore.difficulty,
                                        score: newSecondScore.score))
            highScores.append(HighScore(classification: newThirdScore.difficulty != Difficulty.empty ? 3 : 0,
                                        difficulty: newThirdScore.difficulty,
                                        score: newThirdScore.score))
        } else if finalRoundScore > highScores[1].scoreValue {
            let newFirstScore = HighScoreData(difficulty: highScores[0].difficultyValue,
                                              score: highScores[0].scoreValue)
            let newThirdScore = HighScoreData(difficulty: highScores[1].difficultyValue,
                                              score: highScores[1].scoreValue)
            clearHighScore()
            highScores.append(HighScore(classification: 1, difficulty: newFirstScore.difficulty,
                                        score: newFirstScore.score))
            highScores.append(HighScore(classification: 2, difficulty: difficulty, score: finalRoundScore))
            highScores.append(HighScore(classification: newThirdScore.difficulty != Difficulty.empty ? 3 : 0,
                                        difficulty: newThirdScore.difficulty,
                                        score: newThirdScore.score))
        } else if finalRoundScore > highScores[2].scoreValue {
            let newFirstScore = HighScoreData(difficulty: highScores[0].difficultyValue,
                                              score: highScores[0].scoreValue)
            let newSecondScore = HighScoreData(difficulty: highScores[1].difficultyValue,
                                               score: highScores[1].scoreValue)
            clearHighScore()
            highScores.append(HighScore(classification: 1, difficulty: newFirstScore.difficulty,
                                        score: newFirstScore.score))
            highScores.append(HighScore(classification: 2, difficulty: newSecondScore.difficulty,
                                        score: newSecondScore.score))
            highScores.append(HighScore(classification: 3, difficulty: difficulty, score: finalRoundScore))
        }
    }

    private func clearHighScore() {
        for score in highScores {
            score.removeFromParent()
        }
        highScores.removeAll()
    }

    private func saveNewHighScores() {
        do {
            let newHighScoreData = try JSONEncoder().encode([
                HighScoreData(difficulty: highScores[0].difficultyValue, score: highScores[0].scoreValue),
                HighScoreData(difficulty: highScores[1].difficultyValue, score: highScores[1].scoreValue),
                HighScoreData(difficulty: highScores[2].difficultyValue, score: highScores[2].scoreValue)
            ])
            UserDefaults.standard.setValue(newHighScoreData, forKey: "highScores")
        } catch {
            print(error)
        }
    }
}

class HighScore: SKNode {

    private var classification: SKSpriteNode!
    private var difficulty: SKLabelNode!
    private var score: SKLabelNode!
    public var difficultyValue: Difficulty
    public var scoreValue: Int

    init(classification: Int, difficulty: Difficulty, score: Int) {
        self.difficultyValue = difficulty
        self.scoreValue = score

        self.classification = SKSpriteNode(imageNamed: "trophy" + String(classification))
        self.classification.position = CGPoint(x: -GameConfiguration.gameWidth / 4, y: 0)

        self.difficulty = SKLabelNode()
        self.difficulty.fontName = "SlapAndCrumbly"
        self.difficulty.text = difficulty.rawValue
        self.difficulty.position = CGPoint(x: -100, y: 35)
        self.difficulty.fontColor = difficulty.values().color
        self.difficulty.horizontalAlignmentMode = .left

        self.score = SKLabelNode()
        self.score.fontName = "SlapAndCrumbly"
        self.score.text = String(score)
        self.score.position = CGPoint(x: -100, y: -50)
        self.score.fontSize *= 2
        self.score.horizontalAlignmentMode = .left

        super.init()

        addChild(self.classification)
        addChild(self.difficulty)
        addChild(self.score)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
