//
//  SunAndMoonExampleViewController.swift
//  Example
//
//  Created by Steven Barnegren on 23/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit
import TweenKit

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

// MARK: - Constants
fileprivate let defaultBackgroundColorTop = UIColor(red: 0.263, green: 0.118, blue: 0.565, alpha: 1.00)
fileprivate let defaultBackgroundColorBottom = UIColor(red: 1.000, green: 0.357, blue: 0.525, alpha: 1.00)


class SunAndMoonExampleViewController: UIViewController {
    
    // MARK: - Public
    init(scrubbable: Bool) {
        self.scrubbable = scrubbable
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    private let scrubbable: Bool
    private let scheduler = ActionScheduler(automaticallyAdvanceTime: true)
    private var actionScrubber: ActionScrubber?
    
    // MARK: - Views / Layers
    
    private let slider: UISlider = {
        let slider = UISlider(frame: .zero)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.isUserInteractionEnabled = true
        slider.isContinuous = true
        return slider
    }()
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        return layer
    }()
    
    private let sunMiddle: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 0.965, green: 0.490, blue: 0.125, alpha: 1.00).cgColor
        return layer
    }()
    
    private let sunSideSpoke: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 1.000, green: 0.918, blue: 0.318, alpha: 1.00).cgColor
        return layer
    }()
    
    private let sunDiagonalSpoke: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 1.000, green: 0.918, blue: 0.318, alpha: 1.00).cgColor
        return layer
    }()
    
    private let moon: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.white.cgColor
        layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        let topPoint = CGPoint(x: layer.bounds.size.width/2,
                               y: 0)
        let bottomPoint = CGPoint(x: layer.bounds.size.width/2,
                                  y: layer.bounds.size.height)
        let bottomLeft = CGPoint(x: 0,
                                 y: layer.bounds.size.height)
        let topLeft = CGPoint.zero
        let middle = CGPoint(x: layer.bounds.size.width/2,
                             y: layer.bounds.size.height/2)
        let innerCurvePct = 0.7
        
        let path = UIBezierPath()
        
        let controlPointXOffset = CGFloat(20)
        let controlPointYOffset = CGFloat(50)
       
        // outer curve to bottom
        path.move(to: topPoint)
        path.addArc(withCenter: middle,
                    radius: layer.bounds.size.width/2,
                    startAngle: CGFloat(-90.degreesToRadians),
                    endAngle: CGFloat(90.degreesToRadians),
                    clockwise: false)
        
        // inner curve to top
        path.addCurve(to: topPoint,
                      controlPoint1: bottomLeft,
                      controlPoint2: topLeft)
 
        path.close()
        layer.path = path.cgPath
        
        return layer
    }()

    // MARK: - Animation Variables
    
    /*
     The general pattern here, is that these variables are altered in the action callbacks.
     They then call the update methods on didSet (down at the bottom) to alter the properties of the views.
     If an animation is quite complex, it can be easier to do it this way than to try to animate all of the view properties directly.
 */

    private var sunRadius = CGFloat(50) {
        didSet { updateSun() }
    }
    
    private var sunRotation = CGFloat(0) {
        didSet{ updateSun() }
    }
    
    private var sunSideSpokeSize = CGFloat(1) {
        didSet{ updateSun() }
    }
    
    private var sunOnScreenAmount = CGFloat(0.0) {
        didSet{ updateSun() }
    }
    
    private var sunPosition: CGPoint {
        
        let maxValue = view.center
        let minValue = CGPoint(x: view.center.x,
                               y: view.bounds.size.height + sunRadius + 50)
        
        return minValue.lerp(t: Double(sunOnScreenAmount), end: maxValue)
    }
    
    private var moonOnScreenAmount = CGFloat(0.0) {
        didSet{ updateMoon() }
    }
    
    private var moonPosition: CGPoint {
        
        let maxValue = view.center
        let minValue = CGPoint(x: view.center.x,
                               y: view.bounds.size.height + moon.bounds.size.height)
        
        return minValue.lerp(t: Double(moonOnScreenAmount), end: maxValue)
    }
    
    private var backgroundColorTop = defaultBackgroundColorTop {
        didSet{ updateBackgroundGradient() }
    }
    
    private var backgroundColorBottom = defaultBackgroundColorBottom {
        didSet{ updateBackgroundGradient() }
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add sub layers
        view.layer.addSublayer(gradientLayer)
        view.layer.addSublayer(sunSideSpoke)
        view.layer.addSublayer(sunDiagonalSpoke)
        view.layer.addSublayer(sunMiddle)
        view.layer.addSublayer(moon)
        if scrubbable { view.addSubview(slider) }
        
        // Start the animation
        let moonAppear = makeMoonAction().reversed()
        let sunAppear = makeSunAction()
        let sequence = ActionSequence(actions: moonAppear, sunAppear)
        
        if scrubbable {
            actionScrubber = ActionScrubber(action: sequence)
        }
        else{
            scheduler.run(action: sequence.yoyo().repeatedForever() )
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        
        // Layout Slider
        slider.sizeToFit()
        let margin = CGFloat(5)
        slider.frame = CGRect(x: margin,
                              y: view.bounds.size.height - slider.bounds.size.height - 50,
                              width: view.bounds.size.width - (margin * 2),
                              height: slider.bounds.size.height);
    }
    
    // MARK: - Build Actions
    
    private func makeSunAction() -> FiniteTimeAction {
        
        let duration = 2.0
        
        // Animate the sun on screen
        let moveSunOnScreen = InterpolationAction(from: CGFloat(0.0),
                                                  to: CGFloat(1.0),
                                                  duration: duration,
                                                  easing: .exponentialOut,
                                                  update: { [unowned self] in self.sunOnScreenAmount = $0; self.sunSideSpokeSize = $0 })
        
        // Rotate sun
        let rotateSun = InterpolationAction(from: 0.0,
                                            to: 360.0 * 3.0,
                                            duration: duration + 0.5,
                                            easing: .exponentialOut,
                                            update: { [unowned self] in self.sunRotation = $0})
        
        // Change background color
        let changeBackgroundColorTop = InterpolationAction(from: defaultBackgroundColorTop,
                                                           to: UIColor(red: 0.118, green: 0.376, blue: 0.682, alpha: 1.00),
                                                           duration: duration,
                                                           easing: .exponentialOut,
                                                           update: { [unowned self] in self.backgroundColorTop = $0 })
        
        let changeBackgroundColorBottom = InterpolationAction(from: defaultBackgroundColorBottom,
                                                              to: UIColor(red: 0.569, green: 0.824, blue: 0.941, alpha: 1.00),
                                                              duration: duration,
                                                              easing: .exponentialOut,
                                                              update: { [unowned self] in self.backgroundColorBottom = $0 })
        
        
        // Create group
        let group = ActionGroup(actions: moveSunOnScreen, rotateSun, changeBackgroundColorTop, changeBackgroundColorBottom)
        
        return group
        
    }
    
    private func makeMoonAction() -> FiniteTimeAction {
        
        let duration = 2.0
        
        // animate the moon on screen
        let move = InterpolationAction(from: 0.0,
                                         to: 1.0,
                                         duration: duration,
                                         easing: .exponentialOut,
                                         update: { [unowned self] in self.moonOnScreenAmount = $0 })
        
        // Change background color
        let changeBackgroundColorTop = InterpolationAction(from: defaultBackgroundColorTop,
                                                           to: UIColor(red: 0.114, green: 0.082, blue: 0.133, alpha: 1.00),
                                                           duration: duration,
                                                           easing: .exponentialOut,
                                                           update: { [unowned self] in self.backgroundColorTop = $0 })
        
        let changeBackgroundColorBottom = InterpolationAction(from: defaultBackgroundColorBottom,
                                                              to: UIColor(red: 0.278, green: 0.122, blue: 0.494, alpha: 1.00),
                                                              duration: duration,
                                                              easing: .exponentialOut,
                                                              update: { [unowned self] in self.backgroundColorBottom = $0 })
        
        // Group
        let group = ActionGroup(actions: move, changeBackgroundColorTop, changeBackgroundColorBottom)

        return group
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.actionScrubber?.update(t: 0.0)
    }
    
    // MARK: - Update

    private func updateSun() {
    
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        updateSunMiddle()
        updateSunSideSpoke()
        updateSunDiagonalSpoke()
        
        CATransaction.commit()
    }
    
    private func updateSunMiddle() {
        
        sunMiddle.frame = CGRect(x: sunPosition.x - sunRadius,
                                 y: sunPosition.y - sunRadius,
                                 width: sunRadius * 2,
                                 height: sunRadius * 2)
        
        sunMiddle.cornerRadius = sunMiddle.bounds.size.width/2
    }
    
    private func updateSunSideSpoke() {
        
        sunSideSpoke.transform = CATransform3DIdentity
        
        let sideLength = sunRadius * 2 * sunSideSpokeSize
        sunSideSpoke.frame = CGRect(x: sunPosition.x - sideLength/2,
                                    y: sunPosition.y - sideLength/2,
                                    width: sideLength,
                                    height: sideLength)
        
        let newTransform = CATransform3DMakeRotation(CGFloat(sunRotation.degreesToRadians), 0, 0, 1)
        sunSideSpoke.transform = newTransform
        
    }
    
    private func updateSunDiagonalSpoke() {
        
        sunDiagonalSpoke.transform = CATransform3DIdentity
        
        let sideLength = sunRadius * 2 * sunSideSpokeSize
        sunDiagonalSpoke.frame = CGRect(x: sunPosition.x - sideLength/2,
                                        y: sunPosition.y - sideLength/2,
                                        width: sideLength,
                                        height: sideLength)
        
        let newTransform = CATransform3DMakeRotation(CGFloat((45 + sunRotation).degreesToRadians), 0, 0, 1)
        sunDiagonalSpoke.transform = newTransform
        
    }
    
    private func updateMoon() {
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        moon.frame = CGRect(x: moonPosition.x - moon.bounds.size.width/2,
                            y: moonPosition.y - moon.bounds.size.height/2,
                            width: moon.bounds.size.width,
                            height: moon.bounds.size.height)
        
        CATransaction.commit()
    }
    
    private func updateBackgroundGradient() {
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        gradientLayer.colors = [backgroundColorTop.cgColor, backgroundColorBottom.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [0.0, 1.0]
        
        CATransaction.commit()
    }
    
    // MARK: - Actions
    
    @objc private func sliderValueChanged() {
        actionScrubber?.update(t: Double(slider.value))
    }


}
