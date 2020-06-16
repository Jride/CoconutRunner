//
//  MainMenuView.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 15/06/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import UIKit

class MainMenuView: UIView {
    
    @IBOutlet private var buttonWidthConstraints: [NSLayoutConstraint]!
    @IBOutlet private var cons_playButtonWidth: NSLayoutConstraint!

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
