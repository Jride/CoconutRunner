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

struct Layout {
    
    struct Button {
        static func regular() -> CGFloat { return (Env.gameState.scaleFactor * 70).constrained(min: 40, max: 80) }
        static func large() -> CGFloat { return (Env.gameState.scaleFactor * 100).constrained(min: 70, max: 110) }
    }
    
}

class GameViewController: UIViewController {
    
    @IBOutlet private var healthBarView: HealthBarView!
    @IBOutlet private var pauseButton: UIButton!
    @IBOutlet private var cons_pauseButtonWidth: NSLayoutConstraint!
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
            let scene = GameScene(size: view.frame.size)
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
//            view.showsPhysics = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        Env.gameLogic.add(observer: self, dispatchBehaviour: .onQueue(.main))
        
        setup()
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
    
    private func setup() {
        cons_healthBarWidth.constant = (200 * Env.gameState.scaleFactor).constrained(min: 150)
        cons_pauseButtonWidth.constant = Layout.Button.regular()
    }
}

extension GameViewController {
    
    @IBAction func pauseButtonPressed(_ sender: Any) {
        
        let menu = MenuViewController()
        add(menu, frame: view.frame)
        pauseButton.isHidden = true
    }
    
}

extension GameViewController: GameLogicEventsDispatcherObserver {
    
    func gameResumed() {
        pauseButton.isHidden = false
    }
    
}
