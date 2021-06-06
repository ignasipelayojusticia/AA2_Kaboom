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

        guard let view = self.view as? SKView else { return }
        if let scene = SKScene(fileNamed: "GameScene") {

            var factor = view.frame.size.height / GameConfiguration.gameHeight
            if view.frame.size.width / factor < GameConfiguration.gameWidth {
                factor = view.frame.size.width / GameConfiguration.gameWidth
            }

            scene.size = CGSize(width: view.frame.size.width / factor,
                                height: view.frame.size.height / factor)
            scene.scaleMode = .aspectFit

            view.presentScene(scene)
        }

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
}
