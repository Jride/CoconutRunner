//
//  MenuViewController.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 15/06/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import UIKit
import TweenKit
import FoundationExtended

final class MenuViewController: UIViewController {
    
    enum DisplayContext {
        case mainMenu
        case pause
    }
    
    enum ClosingContext {
        case startNewGame
        case resumePausedGame
        case restartGame
    }
    
    var didClose: ((_ context: ClosingContext) -> Void)?
    var mainMenuPresentedFromPauseState: (() -> Void)?
    
    @IBOutlet private var contentView: UIView!
    
    private let scheduler = ActionScheduler()
    private let screenHeight = UIScreen.main.bounds.height
    private var menuHeight: CGFloat {
        (screenHeight * 0.7).constrained(max: 500)
    }
    private var promptHeight: CGFloat {
        (screenHeight * 0.6).constrained(max: 350)
    }
    
    // Menu's
    private let mainMenu = MainMenuView()
    private let pauseMenu = PauseMenuView()
    private let promptMenu = PromptView()
    
    private var prevMenu: UIView?
    private var currentMenu: UIView?
    
    private let displayContext: DisplayContext
    
    init(displayContext: DisplayContext) {
        self.displayContext = displayContext
        super.init(nibName: nil, bundle: nil)
        
        pauseMenu.delegate = self
        mainMenu.delegate = self
        
        view.addSubview(pauseMenu)
        view.addSubview(promptMenu)
        view.addSubview(mainMenu)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainMenu.frame = view.frame
        mainMenu.isHidden = true
        
        let menuWidth = pauseMenu.width(forHeight: menuHeight)
        pauseMenu.frame = CGRect(x: view.frame.midX - (menuWidth/2),
                                 y: -screenHeight,
                                 width: menuWidth,
                                 height: menuHeight)
        pauseMenu.isHidden = true
        
        let promptWidth = promptMenu.width(forHeight: promptHeight)
        promptMenu.frame = CGRect(x: view.frame.midX - (promptWidth/2),
                                   y: view.frame.midY - (promptHeight/2),
                                   width: promptWidth,
                                   height: promptHeight)
        promptMenu.isHidden = true
        promptMenu.alpha = 0
        
        switch displayContext {
        case .mainMenu:
            
            Env.audioManager.mainMenuPresented()
            currentMenu = mainMenu
            mainMenu.isHidden = false
            
        case .pause:
            
            Env.audioManager.pauseMenuPresented()
            currentMenu = pauseMenu
            pauseMenu.slideInFromTop(scheduler: scheduler, parent: self.view, completion: nil)
        }
    }
    
    private func closeMenu(_ context: ClosingContext) {
        remove()
        didClose?(context)
    }
    
    private func flipToMenuView(_ secondView: UIView, completion: (() -> Void)?) {
        
        guard let currentMenu = currentMenu else { return }
        
        secondView.isHidden = false
        prevMenu = currentMenu
        
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight]
        DispatchQueue.main.async {
            UIView.transition(with: currentMenu, duration: 1.0, options: transitionOptions, animations: {
                currentMenu.alpha = 0
            })
            
            UIView.transition(with: secondView, duration: 1.0, options: transitionOptions, animations: {
                secondView.alpha = 1
            }, completion: { _ in
                self.currentMenu = secondView
                completion?()
            })
        }
    }
    
    private func showPromptWithConfirmResponse(message: String, confirm: @escaping () -> Void) {
        
        promptMenu.configure(withMessage: message)
        
        promptMenu.result = { [weak self] response in
            guard let self = self, let prevMenu = self.prevMenu else { return }
            
            if response == false {
                // Flip back to the previous menu
                self.flipToMenuView(prevMenu, completion: nil)
            } else {
                confirm()
            }
        }
        
        // Show the prompt
        flipToMenuView(promptMenu, completion: nil)
    }

}

// MARK: - Main Menu

extension MenuViewController: MainMenuDelegate {
    
    private func presentMainMenu() {
        
        guard let currentMenu = currentMenu else { return }
        
        mainMenu.frame = view.frame
        mainMenu.alpha = 0
        mainMenu.isHidden = false
        
        currentMenu.slideOutToTop(scheduler: scheduler) { [weak self] in
            
            UIView.animate(withDuration: 0.5, animations: {
                self?.mainMenu.alpha = 1
            }, completion: nil)
            
        }
    }
    
    func mainMenuPlayTapped() {
        closeMenu(.startNewGame)
    }
    
    func mainMenuInfoTapped() {
        
    }
    
}

// MARK: - Pause Menu

extension MenuViewController: PauseMenuDelegate {
    
    func resumePressed() {
        
        // Animate pause menu out
        pauseMenu.slideOutToTop(scheduler: scheduler) { [weak self] in
            self?.closeMenu(.resumePausedGame)
        }
        
    }
    
    func menuPressed() {
        
        let message = "Are you sure you want to return to the main menu?\n\nYour current progress will be lost."
        showPromptWithConfirmResponse(message: message) { [unowned self] in
            self.presentMainMenu()
            self.mainMenuPresentedFromPauseState?()
        }
        
    }
    
    func restartPressed() {
        
        func removeMenu() {
            swipeAwayCurrentMenu { [weak self] in
                guard let self = self else { return }
                self.remove()
                self.didClose?(.restartGame)
            }
        }
        
        let message = "Are you sure you want to restart?\n\nYour current progress will be lost."
        showPromptWithConfirmResponse(message: message) {
            removeMenu()
        }
        
    }
}

// MARK: - Animations

extension MenuViewController {
    
    private func swipeAwayCurrentMenu(completion: @escaping () -> Void) {
        guard let currentMenu = currentMenu else {
            completion()
            return
        }
        
        currentMenu.slideOutToTop(scheduler: scheduler) {
            completion()
        }
    }
    
}
