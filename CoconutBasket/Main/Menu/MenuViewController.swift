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
    private let pauseMenu = PauseMenuView()
    private let screenHeight = UIScreen.main.bounds.height
    private var menuHeight: CGFloat {
        screenHeight * 0.7
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        add(observer: Env.gameLogic, dispatchBehaviour: .onQueue(.main))
        
        pauseMenu.delegate = self
        view.addSubview(pauseMenu)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observerStore.forEach { $0.menuPresented() }
        
        setupAndShowPauseMenu()
    }
    
    private func closeMenu() {
        observerStore.forEach { $0.menuDismissed() }
        remove()
    }

}

// MARK: - Pause Menu Delegate

extension MenuViewController: PauseMenuDelegate {
    
    private func setupAndShowPauseMenu() {
        let menuWidth = pauseMenu.width(forHeight: menuHeight)
        pauseMenu.frame = CGRect(x: view.frame.midX - (menuWidth/2),
                                 y: -screenHeight,
                                 width: menuWidth,
                                 height: menuHeight)
        
        // Animate pause in
        let action = InterpolationAction(
            from: pauseMenu.frame.origin.y,
            to: view.frame.midY - (menuHeight/2),
            duration: 1.0, easing: .exponentialOut
        ) { [unowned self] in
            self.pauseMenu.frame.origin.y = $0
        }
        
        scheduler.run(action: action)
    }
    
    func resumePressed() {
        
        // Animate pause menu out
        let action = InterpolationAction(
            from: pauseMenu.frame.origin.y,
            to: -screenHeight,
            duration: 0.5, easing: .backIn
        ) { [unowned self] in
            self.pauseMenu.frame.origin.y = $0
        }
        
        let completion = RunBlockAction(handler: {
            [unowned self] in
            self.closeMenu()
        })
        
        let sequence = ActionSequence(actions: action, completion)
        
        scheduler.run(action: sequence)
        
    }
    
    func menuPressed() {
        
    }
    
    func restartPressed() {
        
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
