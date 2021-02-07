//
//  CountdownView.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 21/06/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import UIKit
import TweenKit

final class CountdownView: UIView {
    
    private let scheduler = ActionScheduler()
    
    private var threeImage = UIImageView(image: UIImage(named: "three"))
    private var twoImage = UIImageView(image: UIImage(named: "two"))
    private var oneImage = UIImageView(image: UIImage(named: "one"))
    private var goImage = UIImageView(image: UIImage(named: "go"))
    
    private var completionHandler: (() -> Void)?
    
    convenience init(frame: CGRect, completionHandler: @escaping () -> Void) {
        self.init(frame: frame)
        self.completionHandler = completionHandler
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
        
        let allImages = [ threeImage, twoImage, oneImage, goImage ]
        
        allImages.forEach {
            $0.contentMode = .scaleAspectFit
            $0.alpha = 0
            addSubview($0)
            $0.frame = CGRect(x: 0, y: 0,
                              width: frame.width * 2,
                              height: frame.height * 2)
            $0.center = center
        }
        
        animate(images: allImages, prevImage: nil) { [weak self] in
            self?.completionHandler?()
            self?.removeFromSuperview()
        }
    }
    
    private func animate(images: [UIImageView],
                         prevImage: UIImageView?,
                         didComplete: @escaping () -> Void) {
        
        var images = images
        guard let nextImage = images.popFirst() else { return }
        
        var actions = [FiniteTimeAction]()
        
        if let prevImage = prevImage {
            // Fade out
            actions.append(
                InterpolationAction(
                    from: prevImage.alpha,
                    to: 0,
                    duration: 1,
                    easing: .exponentialIn
                ) {
                    prevImage.alpha = $0
                }
            )
        }
        
        // Scale
        actions.append(
            InterpolationAction(
                from: nextImage.frame.size,
                to: CGSize(width: frame.size.width/3,
                           height: frame.size.height/3),
                duration: 1,
                easing: .exponentialIn
            ) { [weak self] in
                guard let self = self else { return }
                nextImage.frame.size = $0
                nextImage.center = self.center
            }
        )
        
        // Fade in
        actions.append(
            InterpolationAction(
                from: nextImage.alpha,
                to: 1,
                duration: 1,
                easing: .exponentialIn
            ) {
                nextImage.alpha = $0
            }
        )
        
        let actionGroup = ActionGroup(actions: actions)
        
        var sequenceActions: [FiniteTimeAction] = [actionGroup]
        
        if images.isEmpty {
            sequenceActions.append(
                DelayAction(duration: 0.5)
            )
        }
        
        sequenceActions.append(
            RunBlockAction(handler: { [weak self] in
                if images.isEmpty {
                    didComplete()
                } else {
                    self?.animate(images: images, prevImage: nextImage, didComplete: didComplete)
                }
            })
        )
        
        let sequence = ActionSequence(actions: sequenceActions)
        
        scheduler.run(action: sequence)
    }
    
}
