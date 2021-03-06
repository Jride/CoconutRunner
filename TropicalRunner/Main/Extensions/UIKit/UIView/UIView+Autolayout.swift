//
//  UIView+Autolayout.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 18/05/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    // MARK: - Pin Width / Height
    
    @discardableResult public func pinWidth(_ width: CGFloat, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = true
        
        let constraint = NSLayoutConstraint.init(item: self,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1,
                                                 constant: width)
        
        if let priority = priority {
            constraint.priority = priority
        }
        
        addConstraint(constraint)
        return constraint
    }
    
    @discardableResult public func pinHeight(_ height: CGFloat, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint.init(item: self,
                                                 attribute: .height,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1,
                                                 constant: height)
        
        if let priority = priority {
            constraint.priority = priority
        }
        
        addConstraint(constraint)
        return constraint
    }
    
    @discardableResult public func pinAspectRatio(width: CGFloat, height: CGFloat, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint.init(item: self,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: self,
                                                 attribute: .height,
                                                 multiplier: width/height,
                                                 constant: 0)
        
        if let priority = priority {
            constraint.priority = priority
        }
        
        addConstraint(constraint)
        return constraint
    }
    
    @discardableResult public func pinAspectRatioSquare(priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        return pinAspectRatio(width: 1, height: 1)
    }
    
    // MARK: - Pin to superview edges
    
    @discardableResult public func pinToSuperviewEdges(priority: UILayoutPriority? = nil) -> [NSLayoutConstraint] {
        return self.pinToSuperviewEdges(top: 0, bottom: 0, leading: 0, trailing: 0, priority: priority)
    }
    
    @discardableResult public func pinToSuperviewEdges(top: CGFloat, bottom: CGFloat, leading: CGFloat, trailing: CGFloat, priority: UILayoutPriority? = nil) -> [NSLayoutConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(pinToSuperviewTop(margin: top, priority: priority))
        constraints.append(pinToSuperviewBottom(margin: bottom, priority: priority))
        constraints.append(pinToSuperviewLeading(margin: leading, priority: priority))
        constraints.append(pinToSuperviewTrailing(margin: trailing, priority: priority))
        
        return constraints
    }
    
    @discardableResult public func pinToSuperviewEdges(insets: UIEdgeInsets, priority: UILayoutPriority? = nil) -> [NSLayoutConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(pinToSuperviewTop(margin: insets.top, priority: priority))
        constraints.append(pinToSuperviewBottom(margin: insets.bottom, priority: priority))
        constraints.append(pinToSuperviewLeading(margin: insets.left, priority: priority))
        constraints.append(pinToSuperviewTrailing(margin: insets.right, priority: priority))
        
        return constraints
    }
    
    @discardableResult public func pinToSuperviewTop(margin: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        return matchAttributeToSuperview(.top, constant: margin, priority: priority)
    }
    
    @discardableResult public func pinToSuperviewBottom(margin: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        return matchAttributeToSuperview(.bottom, constant: margin, priority: priority, invert: true)
    }
    
    @discardableResult public func pinToSuperviewLeft(margin: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        return matchAttributeToSuperview(.left, constant: margin, priority: priority)
    }
    
    @discardableResult public func pinToSuperviewRight(margin: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        return matchAttributeToSuperview(.right, constant: margin, priority: priority, invert: true)
    }
    
    @discardableResult public func pinToSuperviewLeading(margin: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        return matchAttributeToSuperview(.leading, constant: margin, priority: priority)
    }
    
    @discardableResult public func pinToSuperviewTrailing(margin: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        return matchAttributeToSuperview(.trailing, constant: margin, priority: priority, invert: true)
    }
    
    // MARK: - Pin to superview as strip
    
    @discardableResult public func pinToSuperviewAsTopStrip(height: CGFloat, priority: UILayoutPriority? = nil) -> [NSLayoutConstraint] {
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(pinToSuperviewTop(margin: 0, priority: priority))
        constraints.append(pinToSuperviewLeading(margin: 0, priority: priority))
        constraints.append(pinToSuperviewTrailing(margin: 0, priority: priority))
        constraints.append(pinHeight(height, priority: priority))
        
        return constraints
    }
    
    @discardableResult public func pinToSuperviewAsTopStrip(pct: CGFloat, priority: UILayoutPriority? = nil) -> [NSLayoutConstraint] {
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(pinToSuperviewTop(margin: 0, priority: priority))
        constraints.append(pinToSuperviewLeading(margin: 0, priority: priority))
        constraints.append(pinToSuperviewTrailing(margin: 0, priority: priority))
        constraints.append(
            matchAttributeToSuperview(.height, multiplier: pct, constant: 0, priority: priority, invert: false)
        )
        
        return constraints
    }
    
    @discardableResult public func pinToSuperviewAsBottomStrip(height: CGFloat, priority: UILayoutPriority? = nil) -> [NSLayoutConstraint] {
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(pinToSuperviewBottom(margin: 0, priority: priority))
        constraints.append(pinToSuperviewLeading(margin: 0, priority: priority))
        constraints.append(pinToSuperviewTrailing(margin: 0, priority: priority))
        constraints.append(pinHeight(height, priority: priority))
        
        return constraints
    }
    
    @discardableResult public func pinToSuperviewAsLeftStrip(width: CGFloat, priority: UILayoutPriority? = nil) -> [NSLayoutConstraint] {
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(pinToSuperviewLeft(margin: 0, priority: priority))
        constraints.append(pinToSuperviewTop(margin: 0, priority: priority))
        constraints.append(pinToSuperviewBottom(margin: 0, priority: priority))
        constraints.append(pinWidth(width, priority: priority))
        
        return constraints
    }
    
    @discardableResult public func pinToSuperviewAsRightStrip(width: CGFloat, priority: UILayoutPriority? = nil) -> [NSLayoutConstraint] {
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(pinToSuperviewRight(margin: 0, priority: priority))
        constraints.append(pinToSuperviewTop(margin: 0, priority: priority))
        constraints.append(pinToSuperviewBottom(margin: 0, priority: priority))
        constraints.append(pinWidth(width, priority: priority))
        
        return constraints
    }
    
    @discardableResult public func pinToSuperviewAsLeadingStrip(width: CGFloat, priority: UILayoutPriority? = nil) -> [NSLayoutConstraint] {
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(pinToSuperviewLeading(margin: 0, priority: priority))
        constraints.append(pinToSuperviewTop(margin: 0, priority: priority))
        constraints.append(pinToSuperviewBottom(margin: 0, priority: priority))
        constraints.append(pinWidth(width, priority: priority))
        
        return constraints
    }
    
    @discardableResult public func pinToSuperviewAsTrailingStrip(width: CGFloat, priority: UILayoutPriority? = nil) -> [NSLayoutConstraint] {
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(pinToSuperviewTrailing(margin: 0, priority: priority))
        constraints.append(pinToSuperviewTop(margin: 0, priority: priority))
        constraints.append(pinToSuperviewBottom(margin: 0, priority: priority))
        constraints.append(pinWidth(width, priority: priority))
        
        return constraints
    }
    
    // MARK: - Pin to superview center
    
    @discardableResult public func pinToSuperviewCenterX(offset: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        return matchAttributeToSuperview(.centerX, constant: offset)
    }
    
    @discardableResult public func pinToSuperviewCenterY(offset: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        return matchAttributeToSuperview(.centerY, constant: offset)
    }
    
    @discardableResult public func pinToSuperviewCenter(priority: UILayoutPriority? = nil) -> [NSLayoutConstraint] {
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(pinToSuperviewCenterX(priority: priority))
        constraints.append(pinToSuperviewCenterY(priority: priority))
        return constraints
    }
    
    // MARK: - Pin to superview corners
    
    @discardableResult public func pinCenterToSuperviewTopLeft(horizontalOffset: Int = 0, verticalOffset: Int = 0) -> [NSLayoutConstraint] {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            self.centerXAnchor.constraint(equalTo: superview!.leftAnchor, constant: 2),
            self.centerYAnchor.constraint(equalTo: superview!.topAnchor, constant: 2)
        ]
        
        constraints.forEach { $0.isActive = true }
        return constraints
    }
    
    // MARK: - Pin to safe area
    
    @discardableResult public func pinToSafeAreaTop(_ margin: CGFloat = 0) -> NSLayoutConstraint {
        
        guard #available(iOS 11, *) else {
            return pinToSuperviewTop(margin: margin)
        }
        
        guard let superview = superview else { fatalError() }
        
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: superview.safeAreaLayoutGuide,
                                            attribute: .top,
                                            multiplier: 1,
                                            constant: margin)
        superview.addConstraint(constraint)
        
        return constraint
    }
    
    @discardableResult public func pinToSafeAreaRight(_ margin: CGFloat = 0) -> NSLayoutConstraint {
        
        guard #available(iOS 11, *) else {
            return pinToSuperviewRight(margin: margin)
        }
        
        guard let superview = superview else { fatalError() }
        
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: superview.safeAreaLayoutGuide,
                                            attribute: .right,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .right,
                                            multiplier: 1,
                                            constant: margin)
        superview.addConstraint(constraint)
        
        return constraint
    }

    @discardableResult public func pinToSafeAreaBottom(_ margin: CGFloat = 0) -> NSLayoutConstraint {
        
        guard #available(iOS 11, *) else {
            return pinToSuperviewBottom(margin: margin)
        }
        
        guard let superview = superview else { fatalError() }

        translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: superview.safeAreaLayoutGuide,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .bottom,
                                            multiplier: 1,
                                            constant: margin)
        superview.addConstraint(constraint)
        
        return constraint
    }
    
    @discardableResult public func pinToSafeAreaLeft(_ margin: CGFloat = 0) -> NSLayoutConstraint {
        
        guard #available(iOS 11, *) else {
            return pinToSuperviewLeft(margin: margin)
        }
        
        guard let superview = superview else { fatalError() }
        
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .left,
                                            relatedBy: .equal,
                                            toItem: superview.safeAreaLayoutGuide,
                                            attribute: .left,
                                            multiplier: 1,
                                            constant: margin)
        superview.addConstraint(constraint)
        
        return constraint
    }
    
    // MARK: - Pin Outside Superview
    @discardableResult public func pinOutsideSuperviewBottom(separation: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: superview,
                                            attribute: .bottom,
                                            multiplier: 1,
                                            constant: separation)
        superview?.addConstraint(constraint)
        
        return constraint
    }
    
    @discardableResult public func pinOutsideSuperviewTop(separation: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        guard let superview = superview else {
            bailNoSuperview()
        }
        
        let constraint = NSLayoutConstraint(item: superview,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .bottom,
                                            multiplier: 1,
                                            constant: separation)
        superview.addConstraint(constraint)
        
        return constraint
    }
    
    @discardableResult public func pinOutsideSuperviewLeft(separation: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        guard let superview = superview else {
            bailNoSuperview()
        }
        
        let constraint = NSLayoutConstraint(item: superview,
                                            attribute: .left,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .right,
                                            multiplier: 1,
                                            constant: separation)
        superview.addConstraint(constraint)
        
        return constraint
    }
    
    @discardableResult public func pinOutsideSuperviewRight(separation: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .left,
                                            relatedBy: .equal,
                                            toItem: superview,
                                            attribute: .right,
                                            multiplier: 1,
                                            constant: separation)
        superview?.addConstraint(constraint)
        
        return constraint
    }
    
    // MARK: - Pin to other views
    
    @discardableResult public func pinAboveView(_ otherView: UIView, separation: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        otherView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: otherView,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .bottom,
                                            multiplier: 1,
                                            constant: separation)
        
        if let priority = priority {
            constraint.priority = priority
        }
        
        commonSuperviewWithView(otherView).addConstraint(constraint)
        return constraint
    }
    
    @discardableResult public func pinBelowView(_ otherView: UIView, separation: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        return otherView.pinAboveView(self, separation: separation, priority: priority)
    }
    
    @discardableResult public func pinBelowViewLastBaseline(_ otherView: UIView,
                                                            separation: CGFloat = 0,
                                                            priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        otherView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: otherView,
                                            attribute: .lastBaseline,
                                            multiplier: 1,
                                            constant: separation)
        
        if let priority = priority {
            constraint.priority = priority
        }
        
        commonSuperviewWithView(otherView).addConstraint(constraint)
        return constraint
    }
    
    @discardableResult public func pinToLeftOfView(_ otherView: UIView, separation: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        otherView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: otherView,
                                            attribute: .left,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .right,
                                            multiplier: 1,
                                            constant: separation)
        
        if let priority = priority {
            constraint.priority = priority
        }
        
        commonSuperviewWithView(otherView).addConstraint(constraint)
        return constraint
    }
    
    @discardableResult public func pinToRightOfView(_ otherView: UIView, separation: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        return otherView.pinToLeftOfView(self, separation: separation, priority: priority)
    }
    
    @discardableResult public func pinTrailingFromView(_ otherView: UIView, separation: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        otherView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: otherView,
                                            attribute: .trailing,
                                            multiplier: 1,
                                            constant: separation)
        
        if let priority = priority {
            constraint.priority = priority
        }
        
        commonSuperviewWithView(otherView).addConstraint(constraint)
        return constraint
    }
    
    @discardableResult public func pinLeadingToView(_ otherView: UIView, separation: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        return otherView.pinTrailingFromView(self, separation: separation, priority: priority)
    }
    
    @discardableResult public func pinWidthToSameAsView(_ otherView: UIView,
                                                        multiplier: CGFloat = 1,
                                                        priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        otherView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .width,
                                            relatedBy: .equal,
                                            toItem: otherView,
                                            attribute: .width,
                                            multiplier: multiplier,
                                            constant: 0)
        
        if let priority = priority {
            constraint.priority = priority
        }
        
        commonSuperviewWithView(otherView).addConstraint(constraint)
        return constraint
    }
    
    @discardableResult public func pinHeightToSameAsView(_ otherView: UIView,
                                                         multiplier: CGFloat = 1,
                                                         priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        otherView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: otherView,
                                            attribute: .height,
                                            multiplier: multiplier,
                                            constant: 0)
        
        if let priority = priority {
            constraint.priority = priority
        }
        
        commonSuperviewWithView(otherView).addConstraint(constraint)
        return constraint
    }
    
    @discardableResult public func pinToCentre(ofView otherView: UIView,
                                               priority: UILayoutPriority? = nil) -> [NSLayoutConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        otherView.translatesAutoresizingMaskIntoConstraints = false
        
        return [
            pinToCenterX(ofView: otherView, priority: priority),
            pinToCenterY(ofView: otherView, priority: priority)
        ]
    }
    
    @discardableResult public func pinToCenterX(ofView otherView: UIView,
                                                priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        otherView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .centerX,
                                            relatedBy: .equal,
                                            toItem: otherView,
                                            attribute: .centerX,
                                            multiplier: 1,
                                            constant: 0)
        
        if let priority = priority {
            constraint.priority = priority
        }
        
        commonSuperviewWithView(otherView).addConstraint(constraint)
        return constraint
    }
    
    @discardableResult public func pinToCenterY(ofView otherView: UIView,
                                                priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        otherView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .centerY,
                                            relatedBy: .equal,
                                            toItem: otherView,
                                            attribute: .centerY,
                                            multiplier: 1,
                                            constant: 0)
        
        if let priority = priority {
            constraint.priority = priority
        }
        
        commonSuperviewWithView(otherView).addConstraint(constraint)
        return constraint
    }
    
    @discardableResult public func pinTrailingEqualToView(_ otherView: UIView, offset: CGFloat = 0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        otherView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .trailing,
                                            relatedBy: .equal,
                                            toItem: otherView,
                                            attribute: .trailing,
                                            multiplier: 1,
                                            constant: offset)
        
        if let priority = priority {
            constraint.priority = priority
        }
        
        commonSuperviewWithView(otherView).addConstraint(constraint)
        return constraint
    }
    
    // MARK: - Private
    
    private func matchAttributeToSuperview(_ attribute: NSLayoutConstraint.Attribute,
                                           multiplier: CGFloat = 1,
                                           constant: CGFloat = 0,
                                           priority: UILayoutPriority? = nil,
                                           invert: Bool = false) -> NSLayoutConstraint {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: (invert ? superview! : self),
                                            attribute: attribute,
                                            relatedBy: .equal,
                                            toItem: (invert ? self : superview!),
                                            attribute: attribute,
                                            multiplier: multiplier,
                                            constant: constant)
        
        if let priority = priority {
            constraint.priority = priority
        }
        
        superview!.addConstraint(constraint)
        return constraint
    }
    
    private func commonSuperviewWithView(_ otherView: UIView) -> UIView {
        
        var testView = self
        
        while otherView.isDescendant(of: testView) == false {
            
            guard let superview = testView.superview else {
                Swift.print("Views must share a common superview")
                abort()
            }
            
            testView = superview
        }
        
        return testView
    }
    
    func bailNoSuperview() -> Never {
        fatalError("Add view to superview before setting constraints!")
    }
}
