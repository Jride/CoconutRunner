//
//  MainMenuView.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 15/06/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import UIKit
import TweenKit

protocol MainMenuDelegate: class {
    func mainMenuPlayTapped()
    func mainMenuInfoTapped()
}

class MainMenuView: UIView {
    
    @IBOutlet private var buttonWidthConstraints: [NSLayoutConstraint]!
    @IBOutlet private var cons_playButtonWidth: NSLayoutConstraint!
    @IBOutlet private var topBarContainerView: UIView!
    @IBOutlet private var bottomBarContainerView: UIView!
    @IBOutlet private var playButton: UIButton!
    
    weak var delegate: MainMenuDelegate?
    
    private var scheduler = ActionScheduler()

    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        
        backgroundColor = .clear
        
        let nibView = Bundle.main.viewFromNib(withType: UIView.self, nibName: "MainMenuView", owner: self)
        nibView.backgroundColor = .clear
        addSubview(nibView)
        nibView.pinToSuperviewEdges()
        
        let buttonWidth = Layout.Button.regular()
        buttonWidthConstraints.forEach { $0.constant = buttonWidth }
        cons_playButtonWidth.constant = Layout.Button.large()
    }

}

// MARK: - Animations

extension MainMenuView {
    
    private func animateToGameView(complete: @escaping () -> Void) {
        
        let topSectionAction = InterpolationAction(
            from: topBarContainerView.frame.origin.y,
            to: -topBarContainerView.frame.size.height,
            duration: 0.5, easing: .exponentialIn
        ) { [weak self] in
            self?.topBarContainerView.frame.origin.y = $0
        }
        
        let bottomSectionAction = InterpolationAction(
            from: bottomBarContainerView.frame.origin.y,
            to: bottomBarContainerView.frame.origin.y + bottomBarContainerView.frame.size.height,
            duration: 0.5, easing: .exponentialIn
        ) { [weak self] in
            self?.bottomBarContainerView.frame.origin.y = $0
        }
        
        let playButtonAction = InterpolationAction(
            from: playButton.alpha,
            to: 0,
            duration: 0.5, easing: .exponentialIn
        ) { [weak self] in
            self?.playButton.alpha = $0
        }
        
        let completion = RunBlockAction {
            complete()
        }
        
        let actionGroup = ActionGroup(actions: topSectionAction, bottomSectionAction, playButtonAction)
        
        let sequence = ActionSequence(actions: actionGroup, completion)
        
        scheduler.run(action: sequence)
    }
    
}

// MARK: - Actions

extension MainMenuView {
    
    @IBAction private func playButtonPressed(_ sender: Any) {
        animateToGameView { [weak self] in
            self?.delegate?.mainMenuPlayTapped()
        }
    }
    
    @IBAction private func infoButtonPressed(_ sender: Any) {
        delegate?.mainMenuInfoTapped()
    }
    
}
