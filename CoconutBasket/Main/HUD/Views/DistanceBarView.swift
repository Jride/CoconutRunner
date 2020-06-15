//
//  DistanceBarView.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 18/05/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import UIKit
import FoundationExtended
import TweenKit

class DistanceBarView: UIView {
    
    private let scheduler = ActionScheduler()
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var barContainer: UIView!
    @IBOutlet private var barView: UIView!
    @IBOutlet private var barFillerImageView: UIImageView!
    @IBOutlet private var subtitleLabel: UILabel!
    
    private let barWidthRatio: CGFloat = 166.0/300.0
    private let barRatio: CGFloat = 15.0/83.0
    
    private var health: Int = 100
    
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
        
        let nibView = Bundle.main.viewFromNib(withType: UIView.self, nibName: "DistanceBarView", owner: self)
        
        addSubview(nibView)
        nibView.pinToSuperviewEdges()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        barView.frame.origin = CGPoint(x: 0, y: 0)
        updateHudUI()
    }
    
    private func updateHudUI(animated: Bool = false) {
        
        let fullWidth = bounds.width * barWidthRatio
        
        if animated {
            
            let newHealthValue = Int(Env.gameState.playersHealthPercent * 100)
            let prevHealth = health
            health = newHealthValue
            
            let action = InterpolationAction(
                from: prevHealth,
                to: newHealthValue,
                duration: 0.3, easing: .linear) { [unowned self] in
                    
                    self.subtitleLabel.text = "\($0) / 100"
            }
            
            // Run it forever
            scheduler.run(action: action)
            
            UIView.animate(withDuration: 0.3) {
                self.barView.frame.size = CGSize(
                    width: fullWidth * Env.gameState.playersHealthPercent,
                    height: fullWidth * self.barRatio
                )
            }
            
            UIView.animate(withDuration: 0.15, animations: {
                self.barFillerImageView.alpha = 0.4
            }, completion: { (_) in
                UIView.animate(withDuration: 0.15) {
                    self.barFillerImageView.alpha = 1
                }
            })
            
        } else {
            barView.frame.size = CGSize(
                width: fullWidth * Env.gameState.playersHealthPercent,
                height: fullWidth * barRatio
            )
        }
    }
}
