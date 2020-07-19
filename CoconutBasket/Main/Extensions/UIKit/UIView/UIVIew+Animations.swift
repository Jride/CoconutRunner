//
//  UIVIew+Animations.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 10/07/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import Foundation
import UIKit
import TweenKit

extension UIView {
    
    func slideInFromTop(scheduler: ActionScheduler, parent: UIView, delay: TimeInterval? = nil, completion: (() -> Void)?) {
        
        isHidden = false
        let interpAction = InterpolationAction(
            from: frame.origin.y,
            to: parent.frame.midY - (frame.size.height/2),
            duration: 1.0, easing: .exponentialOut
        ) {
            self.frame.origin.y = $0
        }
        
        var actions = [FiniteTimeAction]()
        
        if let timeDelay = delay {
             actions.append(DelayAction(duration: timeDelay))
        }
        
        actions.append(interpAction)
        
        actions.append(
            RunBlockAction(handler: {
                completion?()
            })
        )
        
        let sequence = ActionSequence(actions: actions)
        
        scheduler.run(action: sequence)
    }
    
    func slideOutToTop(scheduler: ActionScheduler, completion: (() -> Void)?) {
        
        let action = InterpolationAction(
            from: frame.origin.y,
            to: -UIScreen.main.bounds.height,
            duration: 0.5, easing: .backIn
        ) {
            self.frame.origin.y = $0
        }
        
        let sequence = ActionSequence(
            actions: action,
            RunBlockAction(handler: {
                completion?()
                self.isHidden = true
        }))
        
        scheduler.run(action: sequence)
    }
    
    // MARK: - Fade in / out
    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }

}
