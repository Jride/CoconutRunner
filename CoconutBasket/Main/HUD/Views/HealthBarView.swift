//
//  HealthBarView.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 18/05/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import UIKit
import FoundationExtended
import TweenKit

extension Int: Tweenable {
    
    public func lerp(t: Double, end: Int) -> Int {
        
        if self > end {
            let amountToTween = self - end
            let move = Int(Double(amountToTween) * t)
            return (self - move).constrained(min: end)
        } else {
            let amountToTween = end - self
            let move = Int(Double(amountToTween) * t)
            return (self + move).constrained(max: end)
        }
    }
    
    public func distanceTo(other: Int) -> Double {
        fatalError("Not implemented")
    }
    
}

class HealthBarView: UIView {
    
    private let scheduler = ActionScheduler()
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var healthBarContainer: UIView!
    @IBOutlet private var healthBar: UIView!
    @IBOutlet private var healthBarFiller: UIImageView!
    @IBOutlet private var healthLabel: UILabel!
    
    private let healthBarWidthRatio: CGFloat = 166.0/300.0
    private let healthBarRatio: CGFloat = 15.0/83.0
    
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
        
        Env.gameState.add(observer: self, dispatchBehaviour: .onQueue(.main))
        
        backgroundColor = .clear
        
        let nibView = Bundle.main.viewFromNib(withType: UIView.self, nibName: "HealthBarView", owner: self)
        
        addSubview(nibView)
        nibView.pinToSuperviewEdges()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        healthBar.frame.origin = CGPoint(x: 0, y: 0)
        updateHudUI()
    }
    
    private func updateHudUI(animated: Bool = false) {
        
        let fullWidth = bounds.width * healthBarWidthRatio
        
        if animated {
            
            let newHealthValue = Int(Env.gameState.playersHealthPercent * 100)
            let prevHealth = health
            health = newHealthValue
            
            let action = InterpolationAction(
                from: prevHealth,
                to: newHealthValue,
                duration: 0.3, easing: .linear) { [unowned self] in
                    
                    self.healthLabel.text = "\($0) / 100"
            }
            
            // Run it forever
            scheduler.run(action: action)
            
            UIView.animate(withDuration: 0.3) {
                self.healthBar.frame.size = CGSize(
                    width: fullWidth * Env.gameState.playersHealthPercent,
                    height: fullWidth * self.healthBarRatio
                )
            }
            
            UIView.animate(withDuration: 0.15, animations: {
                self.healthBarFiller.alpha = 0.4
            }, completion: { (_) in
                UIView.animate(withDuration: 0.15) {
                    self.healthBarFiller.alpha = 1
                }
            })
            
        } else {
            healthBar.frame.size = CGSize(
                width: fullWidth * Env.gameState.playersHealthPercent,
                height: fullWidth * healthBarRatio
            )
        }
    }
}

extension HealthBarView: GameStateDispatcherObserver {
    func playersHealthDidUpdate() {
        updateHudUI(animated: true)
    }
}
