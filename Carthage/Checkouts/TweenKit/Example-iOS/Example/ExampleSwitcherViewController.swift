//
//  ExampleViewController.swift
//  Example
//
//  Created by Steven Barnegren on 23/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit

// MARK: - ***** ExampleType enum *****

enum ExampleType: Int {
    
    case basicTween
    case activityIndicator
    case sunAndMoon
    case sunAndMoonScrubbable
    case easingExamples
    case bezierQuadCurve
    case bezierCubicCurve
    case stringTween
    case onboarding

    var count: Int {
        
        var rawValue = 0
        
        while let _ = ExampleType(rawValue: rawValue) {
            rawValue += 1
        }
        
        return rawValue
    }
    
    func next() -> ExampleType {
        var raw = self.rawValue
        raw += 1
        if let nextValue = ExampleType(rawValue: raw) {
            return nextValue
        }
        return ExampleType(rawValue: 0)!
    }
    
    func previous() -> ExampleType {
        
        var raw = self.rawValue
        raw -= 1
        if raw < 0 {
            return ExampleType(rawValue: count-1)!
        }
        else{
            return ExampleType(rawValue: raw)!
        }
    }
    
    func makeViewController() -> UIViewController {
        switch self {
        case .basicTween:
            return BasicTweenViewController(nibName: nil, bundle: nil)
        case .activityIndicator:
            return ActivityIndicatorExampleViewController(nibName: nil, bundle: nil)
        case .sunAndMoon:
            return SunAndMoonExampleViewController(scrubbable: false)
        case .sunAndMoonScrubbable:
            return SunAndMoonExampleViewController(scrubbable: true)
        case .easingExamples:
            return EasingExamplesViewController(nibName: nil, bundle: nil)
        case .bezierQuadCurve:
            return BezierCurveExampleViewController(model: QuadCurveDemoModel())
        case .bezierCubicCurve:
            return BezierCurveExampleViewController(model: CubicCurveDemoModel())
        case .onboarding:
            return OnboardingExampleViewController(nibName: nil, bundle: nil)
        case .stringTween:
            return StringTweenViewController(nibName: nil, bundle: nil)
        }
    }
}

// MARK: - ***** ExampleSwitcherViewController *****

class ExampleSwitcherViewController: UIViewController {
    
    // MARK: - Properties
    var contentViewController: UIViewController? = nil
    var exampleType = ExampleType(rawValue: 0)!
    
    // MARK: - Views
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed(sender:)), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.addTarget(self, action: #selector(nextButtonPressed(sender:)), for: .touchUpInside)
        return button
    }()

    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        // Add subviews
        view.addSubview(backButton)
        view.addSubview(nextButton)
                
        // Show the first example
        let startViewController = exampleType.makeViewController()
        setContentViewController(to: startViewController)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let buttonMargins = CGFloat(8)
        
        // Back button
        backButton.sizeToFit()
        backButton.frame.origin = CGPoint(x: buttonMargins,
                                          y: view.bounds.size.height - buttonMargins - backButton.bounds.size.height)
        
        // Next button
        nextButton.sizeToFit()
        nextButton.frame.origin = CGPoint(x: view.bounds.size.width - buttonMargins - nextButton.bounds.size.width,
                                          y: view.bounds.size.height - buttonMargins - nextButton.bounds.size.height)
        
        contentViewController?.view.frame = view.bounds
        
        // Content view controller
        /*
        if let content = contentViewController {
            
            content.view.frame = CGRect(x: 0,
                                        y: 0,
                                        width: self.view.bounds.size.width,
                                        height: backButton.frame.origin.y - buttonMargins)
        }
 */
    }
    
    // MARK: - Methods
    
    @objc private func backButtonPressed(sender: UIButton) {
        print("Back button pressed")
        
        exampleType = exampleType.previous()
        let viewController = exampleType.makeViewController()
        setContentViewController(to: viewController)
        
    }

    @objc private func nextButtonPressed(sender: UIButton) {
        print("Next button pressed")
        
        exampleType = exampleType.next()
        let viewController = exampleType.makeViewController()
        setContentViewController(to: viewController)
    }
    
    private func setContentViewController(to viewController: UIViewController) {
        
        if let existing = contentViewController {
            existing.removeFromParent()
            existing.view.removeFromSuperview()
        }
        
        contentViewController = nil
        
        addChild(viewController)
        view.addSubview(viewController.view)
        view.sendSubviewToBack(viewController.view)
        contentViewController = viewController
        
        view.setNeedsLayout()
    }
}
