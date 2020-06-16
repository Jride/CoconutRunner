//
//  MainMenuView.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 15/06/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import UIKit

class MainMenuView: UIView {
    
    @IBOutlet private var buttons: [UIButton]!
    @IBOutlet private var playButton: UIButton!

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
        
        addSubview(nibView)
        nibView.pinToSuperviewEdges()
        
        let buttonWidth = Layout.Button.regular()
        buttons.forEach {
            $0.pinWidth(buttonWidth)
        }
        playButton.pinWidth(Layout.Button.large())
    }

}
