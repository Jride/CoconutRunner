//
//  PauseMenuView.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 15/06/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import UIKit

protocol PauseMenuDelegate: class {
    func resumePressed()
    func menuPressed()
    func restartPressed()
}

class PauseMenuView: UIView {
    
    @IBOutlet private var messageLabel: UILabel!
    
    weak var delegate: PauseMenuDelegate?
    
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
        
        let nibView = Bundle.main.viewFromNib(withType: UIView.self, nibName: "PauseMenuView", owner: self)
        addSubview(nibView)
        nibView.pinToSuperviewEdges()
        nibView.backgroundColor = .clear
        
        messageLabel.text = randomMessage()
    }

}

// MARK: - Actions

extension PauseMenuView {
    
    @IBAction private func resumeButtonPressed(_ sender: Any) {
        delegate?.resumePressed()
    }
    
    @IBAction private func menuButtonPressed(_ sender: Any) {
        delegate?.menuPressed()
    }
    
    @IBAction private func restartButtonPressed(_ sender: Any) {
        delegate?.restartPressed()
    }
    
}

// MARK: - Messages

extension PauseMenuView {
    
    private func randomMessage() -> String {
        
        return [
            "In this game, everyone needs a break to refuel, recharge, and jump back in full throttle.",
            "Drink a cup of tea",
            "Have a coffee and recharge",
            "When in doubt, chill out",
            "If you get tired learn to rest. Not to quit",
            "It's ok to take a break",
            "... and relax",
            "Relax and accept the crazy",
            "Just breathe... you can do this"
            ].randomElement().require("")
        
    }
    
}

// MARK: - Public
extension PauseMenuView {
    
    func width(forHeight height: CGFloat) -> CGFloat {
        let widthToHeightRatio: CGFloat = 572.0/572.0
        return widthToHeightRatio * height
    }
    
}
