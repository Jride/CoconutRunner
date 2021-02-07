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

final class DistanceBarView: UIView {
    
    private let scheduler = ActionScheduler()
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var barContainer: UIView!
    @IBOutlet private var barView: UIView!
    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var levelLabel: UILabel!
    
    private let barWidthRatio: CGFloat = 180.0/300.0
    private let barRatio: CGFloat = 15.0/83.0
    
    private var progress: Int = 0
    private var distanceProgress: CGFloat {
        Env.gameState.playersDistanceStats.levelsDistanceProgress
    }
    private var overallDistance: Int {
        Env.gameState.playersDistanceStats.overallDistance
    }
    private var currentLevel: Int {
        Env.gameLogic.currentLevelConfig.level
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
        
        Env.gameState.add(observer: self, dispatchBehaviour: .onQueue(.main))
        
        backgroundColor = .clear
        
        let nibView = Bundle.main.viewFromNib(withType: UIView.self, nibName: "DistanceBarView", owner: self)
        
        addSubview(nibView)
        nibView.pinToSuperviewEdges()
        
        subtitleLabel.text = "0 M"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        barView.frame.origin = CGPoint(x: 0, y: 0)
        updateHudUI()
    }
    
    private func updateHudUI(animated: Bool = false) {
        
        let fullWidth = bounds.width * barWidthRatio
        
        if animated {
            
            let prevProgress = progress
            progress = overallDistance
            
            let action = InterpolationAction(
                from: prevProgress,
                to: progress,
                duration: 0.3, easing: .linear) { [unowned self] in
                    
                    self.subtitleLabel.text = "\($0) M"
            }
            
            scheduler.run(action: action)
            
            UIView.animate(withDuration: 0.3) {
                self.barView.frame.size = CGSize(
                    width: fullWidth * self.distanceProgress,
                    height: fullWidth * self.barRatio
                )
            }
            
        } else {
            barView.frame.size = CGSize(
                width: fullWidth * distanceProgress,
                height: fullWidth * barRatio
            )
        }
        
        levelLabel.text = "LEVEL \(currentLevel)"
    }
}

extension DistanceBarView: GameStateDispatcherObserver {
    
    func playersDistanceStatsDidUpdate() {
        updateHudUI(animated: true)
    }
    
    func resetGameState() {
        updateHudUI(animated: true)
    }
    
}
