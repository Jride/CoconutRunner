//
//  EasingExamplesViewController.swift
//  Example
//
//  Created by Steven Barnegren on 27/03/2017.
//  Copyright © 2017 Steve Barnegren. All rights reserved.
//

import UIKit
import TweenKit

class EasingExamplesViewController: UIViewController {
    
    // MARK: - Types
    
    fileprivate struct CellModel {
        let easing: Easing
        var value = 0.0
    }
    
    // MARK: - Constants
    
    fileprivate let cellClassName = "EasingExampleCell"
    
    // MARK: - Properties
    
    fileprivate let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset.top = 50
        tableView.allowsSelection = false
        return tableView
    }()
    
    fileprivate var cellModels: [CellModel] = {
        
        return Easing.all().map{
            CellModel(easing: $0, value: 0.0)
        }
    }()
    
    fileprivate let scheduler = ActionScheduler()
    fileprivate var hasStartedAnimation = false
    
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell
        let nib = UINib(nibName: cellClassName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellClassName)
        
        // Add subviews
        view.addSubview(tableView)
        
        // Reload table
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        if !hasStartedAnimation {
            startAnimation()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    // MARK: - Animation
    
    fileprivate func startAnimation(){
        
        let action = InterpolationAction(from: 0.0, to: 1.0, duration: 2.0, easing: .linear) {
            [unowned self] in
            
            for i in 0..<self.cellModels.count {
                let easing = self.cellModels[i].easing
                self.cellModels[i].value = easing.apply(t: $0)
            }
            
            self.updateTableCells()
        }
        
        let sequence = ActionSequence(actions: DelayAction(duration: 0.5), action, DelayAction(duration: 0.5))
        let repeated = sequence.repeatedForever()
        scheduler.run(action: repeated)
        
        hasStartedAnimation = true
    }

}

// MARK: - Manage Table

extension EasingExamplesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellModel = cellModels[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellClassName) as! EasingExampleCell
        cell.setTitle(title: cellModel.easing.name)
        cell.animatedPct = cellModel.value
        return cell
    }
    
    func updateTableCells() {
        
        for cell in tableView.visibleCells {
            
            guard let cell = cell as? EasingExampleCell else {
                continue
            }
            
            guard let indexPath = tableView.indexPath(for: cell) else {
                continue
            }
            
            let cellModel = cellModels[indexPath.row]
            cell.animatedPct = cellModel.value
        }
    }
}

// MARK: - TweenKit.Easing Extension

extension Easing {
    
    static func all() -> [Easing] {
        
        var array = [Easing]()
        var num = 0
        
        while let easing = Easing(rawValue: num) {
            array.append(easing)
            num += 1
        }
        return array
    }
    
    var name: String {
        
        switch self {
        case .linear: return "Linear"
        case .sineIn: return "Sine In"
        case .sineOut: return "Sine Out"
        case .sineInOut: return "Sine In Out"
        case .exponentialIn: return "Exponential In"
        case .exponentialOut: return "Exponential Out"
        case .exponentialInOut: return "Exponential In Out"
        case .backIn: return "Back In"
        case .backOut: return "Back Out"
        case .backInOut: return "Back In Out"
        case .bounceIn: return "Bounce In"
        case .bounceOut: return "Bounce Out"
        case .bounceInOut: return "Bounce In Out"
        case .elasticIn: return "Elastic In"
        case .elasticOut: return "Elastic Out"
        case .elasticInOut: return "Elastic In Out"
        }
    }
}
