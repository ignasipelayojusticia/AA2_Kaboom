//
//  GameViewController.swift
//  Kaboom
//
//  Created by Alumne on 15/4/21.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        loadScene(sceneName: "SplashScreen")

        guard let view = self.view as? SKView else { return }
        view.ignoresSiblingOrder = true

        view.showsFPS = true
        view.showsNodeCount = true
        view.showsPhysics = true
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    public func setSceneProperties(view: SKView, skScene: SKScene) {

        guard let scene = skScene as? Scene else {return}
        scene.gameViewController = self

        var factor = view.frame.size.height / GameConfiguration.gameHeight
        if view.frame.size.width / factor < GameConfiguration.gameWidth {
            factor = view.frame.size.width / GameConfiguration.gameWidth
        }

        scene.size = CGSize(width: view.frame.size.width / factor,
                            height: view.frame.size.height / factor)
        scene.scaleMode = .aspectFit

        view.presentScene(scene, transition: SKTransition.fade(with: UIColor.black, duration: 1))
    }

    public func loadScene(sceneName: String) {

        guard let view = self.view as? SKView else { return }

        switch sceneName {
        case "SplashScreen":
            if let skScene = SKScene(fileNamed: "SplashScreenScene") {
                setSceneProperties(view: view, skScene: skScene)
            }

        case "MainMenu":
            if let skScene = SKScene(fileNamed: "MainMenuScene") {
                setSceneProperties(view: view, skScene: skScene)
            }

        case "Game":
            if let skScene = SKScene(fileNamed: "GameScene") {
                setSceneProperties(view: view, skScene: skScene)
            }

        case "HighScores":
            if let skScene = SKScene(fileNamed: "HighScoresScene") {
                setSceneProperties(view: view, skScene: skScene)
            }
        default:
            break
        }
    }
}
