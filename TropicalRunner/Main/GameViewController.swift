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

struct Layout {
    
    struct Button {
        static func regular() -> CGFloat { return (Env.gameState.scaleFactor * 70).constrained(min: 40, max: 80) }
        static func large() -> CGFloat { return (Env.gameState.scaleFactor * 150).constrained(min: 110, max: 170) }
    }
    
}

final class GameViewController: UIViewController {
    
    @IBOutlet private var healthBarView: HealthBarView!
    @IBOutlet private var distanceBarView: DistanceBarView!
    @IBOutlet private var pauseButton: UIButton!
    @IBOutlet private var cons_pauseButtonWidth: NSLayoutConstraint!
    @IBOutlet private var cons_healthBarWidth: NSLayoutConstraint!
    
    var scene: GameScene!
    
    private var isDisplayingMenu = false
    
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
            
            self.scene = scene
        }
        
        Env.gameLogic.add(observer: self, dispatchBehaviour: .onQueue(.main))
        Env.applicationEventsDispatcher.add(observer: self, dispatchBehaviour: .onQueue(.main))
        
        setup()
        showMainMenu()
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
    
    private func showMainMenu(animated: Bool = false) {
        let menu = MenuViewController(displayContext: .mainMenu)
        menu.didClose = { [unowned self] (context) in
            self.menuDidClose(context)
        }
        menu.view.alpha = animated ? 0 : 1
        add(menu, frame: view.frame)
        if animated {
            menu.view.fadeIn()
        }
        isDisplayingMenu = true
    }
    
    private func menuDidClose(_ context: MenuViewController.ClosingContext) {
        
        self.isDisplayingMenu = false
        
        if context == .resumePausedGame {
            Env.gameLogic.resumeGame()
        } else {
            Env.gameState.reset()
            let countdown = CountdownView(frame: view.frame) {
                // Countdown finished
                switch context {
                case .startNewGame:
                    Env.gameLogic.startGame()
                case .restartGame:
                    Env.gameLogic.restartGame()
                default:
                    break
                }
            }
            view.addSubview(countdown)
        }
    }
}

extension GameViewController {
    
    private func presentPauseMenuIfRequired() {
        
        guard isDisplayingMenu == false else { return }
        
        isDisplayingMenu = true
        let menu = MenuViewController(displayContext: .pause)
        menu.didClose = { [unowned self] (context) in
            self.menuDidClose(context)
        }
        menu.mainMenuPresentedFromPauseState = {
            Env.gameState.reset()
        }
        add(menu, frame: view.frame)
        pauseButton.isHidden = true
        scene.pauseGameScene()
    }
    
    @IBAction func pauseButtonPressed(_ sender: Any) {
        presentPauseMenuIfRequired()
    }
    
}

extension GameViewController: GameLogicEventsDispatcherObserver {
    
    func startLevel(withConfig config: LevelConfiguration) {
        pauseButton.isHidden = false
    }
    
    func gameResumed() {
        pauseButton.isHidden = false
    }
    
    func gameOver() {
        
        func showStats() {
            let statsView = GameStatsViewController.present(on: self)
            statsView.didClose = { [weak self] in
                self?.showMainMenu(animated: true)
            }
        }
        
        // Present Game Over Image
        
        let image = UIImageView(image: UIImage(named: "gameOver")!)
        let ratio: CGFloat = 298.0/1104.0
        let newWidth: CGFloat = 650 * Env.gameState.scaleFactor
        let newHeight = newWidth * ratio
        image.frame = CGRect(
            x: view.center.x - (newWidth/2),
            y: view.center.y - (newHeight/2),
            width: newWidth,
            height: newHeight
        )
        image.alpha = 0
        
        view.addSubview(image)
        
        let fadeOut = {
            image.fadeOut(0.5, delay: 3) { _ in
                showStats()
            }
        }
        
        image.fadeIn(0.5, delay: 0.5) { _ in
            fadeOut()
        }
    }
    
}

extension GameViewController: ApplicationEventsDispatcherObserver {
    
    func applicationWillResignActive() {
        presentPauseMenuIfRequired()
    }
    
    func applicationDidBecomeActive(fromBackground: Bool) {
        if isDisplayingMenu {
            scene.view?.isPaused = true
        }
    }
    
}
