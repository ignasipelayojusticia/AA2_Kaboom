//
//  GameViewController.swift
//  Kaboom
//
//  Created by Alumne on 15/4/21.
//

import UIKit
import SpriteKit

enum GameConfiguration {
    enum Core {
        static let gameWidth: CGFloat = 960
        static let gameHeight: CGFloat = 540
    }
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var factor = view.frame.size.height / GameConfiguration.Core.gameHeight

        if view.frame.size.width / factor < GameConfiguration.Core.gameWidth {
            factor = view.frame.size.width / GameConfiguration.Core.gameWidth
        }

        let sceneSize = CGSize(width: view.frame.size.width / factor,
                               height: view.frame.size.height / factor)

        guard let view = self.view as? SKView else { return }
        // Load the SKScene from 'GameScene.sks'
        if let scene = SKScene(fileNamed: "GameScene") {
            // Set the scale mode to scale to fit the window
            scene.size = sceneSize
            scene.scaleMode = .aspectFit
            // Present the scene
            view.presentScene(scene)
        }

        view.ignoresSiblingOrder = true

        view.showsFPS = true
        view.showsNodeCount = true
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
}
