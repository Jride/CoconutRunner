//
//  PromptView.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 16/06/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import UIKit
import FoundationExtended

final class PromptView: UIView {
    
    @IBOutlet private var messageLabel: UILabel!
    
    var result: ((Bool) -> Void)?

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
        
        let nibView = Bundle.main.viewFromNib(withType: UIView.self, nibName: "PromptView", owner: self)
        addSubview(nibView)
        nibView.pinToSuperviewEdges()
        nibView.backgroundColor = .clear
        
        messageLabel.textColor = .black
        
        configure(withMessage: "Are you sure?")
    }
    
    @IBAction private func yesButtonPressed(_ sender: Any) {
        result?(true)
    }
    
    @IBAction private func noButtonPressed(_ sender: Any) {
        result?(false)
    }
}

// MARK: - Public
extension PromptView {
    
    func configure(withMessage message: String) {
        messageLabel.text = message
    }
    
    func width(forHeight height: CGFloat) -> CGFloat {
        let widthToHeightRatio: CGFloat = 412.0/380.0
        return widthToHeightRatio * height
    }
    
}
