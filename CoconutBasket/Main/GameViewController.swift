//
//  GameViewController.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 06/04/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import AVKit
import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    @IBOutlet private var healthBarView: HealthBarView!
    @IBOutlet private var cons_healthBarWidth: NSLayoutConstraint!

    override func viewDidLoad() {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print(error.localizedDescription)
        }
        
        super.viewDidLoad()
        
        if let view = self.view as? SKView {
            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene(size: view.frame.size)
            // Present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            view.showsPhysics = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        cons_healthBarWidth.constant = (200 * Env.gameState.scaleFactor).constrained(min: 150)
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
