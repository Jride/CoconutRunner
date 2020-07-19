//
//  StatsItemView.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 14/07/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import UIKit
import FoundationExtended
import TweenKit

class StatsItemView: UIView {
    
    @IBOutlet private var iconImage: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var valueLabel: UILabel!
    @IBOutlet private var scoreLabel: UILabel!
    
    var statsCoordinator: StatsCoordinator?
    var stat: Stat = .health
    
    struct Config {
        let statsCoordinator: StatsCoordinator
        let stat: Stat
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
        
        let nibView = Bundle.main.viewFromNib(withType: UIView.self, nibName: "StatsItemView", owner: self)
        
        addSubview(nibView)
        nibView.pinToSuperviewEdges()
        
        backgroundColor = .clear
        nibView.backgroundColor = .clear
    }
    
    func configure(with config: Config) {
        statsCoordinator = config.statsCoordinator
        
        stat = config.stat
        iconImage.image = stat.icon
        titleLabel.text = "\(stat.title):"
        valueLabel.text = "0"
        valueLabel.textColor = stat.textColor
        scoreLabel.text =  "0"
    }
    
}

extension StatsItemView: Animating {
    
    func runAnimation(with scheduler: ActionScheduler, completion: @escaping () -> Void) {
        
        guard let coordinator = statsCoordinator else {
            completion()
            return
        }
        
        let (value, score) = coordinator.score(for: stat)
        
        let duration: TimeInterval = 1
        
        let valueAction = InterpolationAction(
            from: 0,
            to: value,
            duration: duration, easing: .linear) { [weak self] in
                self?.valueLabel.text = "\($0)"
        }
        
        var plusMinus = score.isPositive ? "+" : "-"
        plusMinus = score == 0 ? "" : plusMinus
        
        let scoreAction = InterpolationAction(
            from: 0,
            to: score.abs,
            duration: duration, easing: .linear) { [weak self] in
                self?.scoreLabel.text = "\(plusMinus)\($0)"
        }
        
        let group = ActionGroup(actions: [
            valueAction,
            scoreAction
        ])
        
        let sequence = ActionSequence(actions: [
            group,
            RunBlockAction(handler: {
                completion()
            })
        ])
        
        scheduler.run(action: sequence)
        
    }
}