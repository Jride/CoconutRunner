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

final class StatsItemView: UIView {
    
    @IBOutlet private var iconImage: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var valueLabel: UILabel!
    @IBOutlet private var scoreLabel: UILabel!
    @IBOutlet private var cons_iconWidth: NSLayoutConstraint!
    
    private var statsCoordinator: StatsCoordinator?
    var stat: Stat = .damage
    
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
        
        cons_iconWidth.constant = Env.gameState.scaleFactor * 50
        
        var fontSize: CGFloat = Env.device.isPad ? 25 : 20
        fontSize = fontSize * Fonts.fontCoefficient
        
        [scoreLabel,
         titleLabel,
         valueLabel].forEach { $0.font = Fonts.soupOfJustice(size: fontSize) }
    }
    
    func configure(with config: Config) {
        statsCoordinator = config.statsCoordinator
        stat = config.stat
        iconImage.image = stat.icon
        titleLabel.text = "\(stat.title):"
        valueLabel.text = stat.readableValue
        valueLabel.textColor = stat.textColor
        scoreLabel.text =  "0"
        scoreLabel.textColor = stat.textColor
    }
    
}

extension StatsItemView: Animating {
    
    func runAnimation(with scheduler: ActionScheduler, completion: @escaping () -> Void) {
        
        guard let coordinator = statsCoordinator,
            let totalScoreView = coordinator.footerView else {
            completion()
            return
        }
        
        let score = coordinator.score(for: stat)
        
        var actions = [FiniteTimeAction]()
        
        var plusMinus = score.isPositive ? "+" : "-"
        plusMinus = score == 0 ? "" : plusMinus
        
        let scoreAction = InterpolationAction(
            from: 0,
            to: score.abs,
            duration: stat.animationDuration.seconds, easing: .linear) { [weak self] in
                self?.scoreLabel.text = "\(plusMinus)\($0)"
        }
        
        actions.append(scoreAction)
        
        if let currentTotal = Int(totalScoreView.rhsText) {
            
            let totalScoreAction = InterpolationAction(
                from: currentTotal,
                to: coordinator.totalScore,
                duration: stat.animationDuration.seconds, easing: .linear) {
                    totalScoreView.rhsText = "\($0)"
            }
            
            actions.append(totalScoreAction)
        }
        
        stat.sound.play()
        
        let sequence = ActionSequence(actions: [
            ActionGroup(actions: actions),
            DelayAction(duration: 0.3),
            RunBlockAction(handler: {
                completion()
            })
        ])
        
        scheduler.run(action: sequence)
        
    }
}
