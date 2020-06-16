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

class MenuViewController: UIViewController, MenuDispatcher, Observable {
    
    var observerStore = ObserverStore<MenuDispatcherObserver>()
    
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
    private var promptMenu = PromptView()
    
    private var prevMenu: UIView?
    private var currentMenu: UIView?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        add(observer: Env.gameLogic, dispatchBehaviour: .onQueue(.main))
        
        pauseMenu.delegate = self
        view.addSubview(pauseMenu)
        
        promptMenu.alpha = 0
        view.addSubview(promptMenu)
        
        mainMenu.alpha = 0
        mainMenu.isHidden = true
        view.addSubview(mainMenu)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observerStore.forEach { $0.menuPresented() }
        
        currentMenu = pauseMenu
        let menuWidth = pauseMenu.width(forHeight: menuHeight)
        pauseMenu.frame = CGRect(x: view.frame.midX - (menuWidth/2),
                                 y: -screenHeight,
                                 width: menuWidth,
                                 height: menuHeight)
        
        animateMenuSwipe(pauseMenu, display: true, completion: nil)
    }
    
    private func closeMenu() {
        observerStore.forEach { $0.menuDismissed() }
        remove()
    }
    
    private func flipToMenuView(_ secondView: UIView, completion: (() -> Void)?) {
        
        guard let currentMenu = currentMenu else { return }
        
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
        
        let promptWidth = promptMenu.width(forHeight: promptHeight)
        promptMenu.frame = CGRect(x: view.frame.midX - (promptWidth/2),
                                   y: view.frame.midY - (promptHeight/2),
                                   width: promptWidth,
                                   height: promptHeight)
        
        // Show the prompt
        flipToMenuView(promptMenu, completion: nil)
    }

}

// MARK: - Main Menu

extension MenuViewController {
    
    private func presentMainMenu() {
        
        guard let currentMenu = currentMenu else { return }
        
        mainMenu.frame = view.frame
        mainMenu.alpha = 0
        mainMenu.isHidden = false
        
        animateMenuSwipe(currentMenu, display: false) { [weak self] in
            
            UIView.animate(withDuration: 0.5, animations: {
                self?.mainMenu.alpha = 1
            }, completion: { _ in
                
            })
            
        }
    }
    
}

// MARK: - Pause Menu

extension MenuViewController: PauseMenuDelegate {
    
    func resumePressed() {
        
        // Animate pause menu out
        animateMenuSwipe(pauseMenu, display: false) { [weak self] in
            self?.closeMenu()
        }
        
    }
    
    func menuPressed() {
        
        let message = "Are you sure?\n\nYour current progress will be lost."
        showPromptWithConfirmResponse(message: message) { [unowned self] in
            self.presentMainMenu()
        }
        
    }
    
    func restartPressed() {
        
        let message = "Are you sure?\n\nYour current progress will be lost."
        showPromptWithConfirmResponse(message: message) { [unowned self] in
            
        }
        
    }
}

// MARK: - Animations

extension MenuViewController {
    
    private func animateMenuSwipe(_ menu: UIView, display: Bool, completion: (() -> Void)?) {
        
        if display {
            
            let action = InterpolationAction(
                from: menu.frame.origin.y,
                to: view.frame.midY - (menu.frame.size.height/2),
                duration: 1.0, easing: .exponentialOut
            ) {
                menu.frame.origin.y = $0
            }
            
            let sequence = ActionSequence(actions: action,
                                          RunBlockAction(handler: {
                completion?()
            }))
            
            scheduler.run(action: sequence)
            
        } else {
            
            let action = InterpolationAction(
                from: menu.frame.origin.y,
                to: -screenHeight,
                duration: 0.5, easing: .backIn
            ) {
                menu.frame.origin.y = $0
            }
            
            let sequence = ActionSequence(actions: action,
                                          RunBlockAction(handler: {
                completion?()
            }))
            
            scheduler.run(action: sequence)
            
        }
        
    }
    
}

// MARK: - Menu Dispather

protocol MenuDispatcherObserver: class {
    func menuPresented()
    func menuDismissed()
}

extension MenuDispatcherObserver {
    func menuPresented() {}
    func menuDismissed() {}
}

protocol MenuDispatcher {
    func add(observer: MenuDispatcherObserver, dispatchBehaviour: DispatchBehaviour)
    func remove(observer: MenuDispatcherObserver)
}
