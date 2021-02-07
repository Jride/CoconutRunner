//
//  StatsHeaderFooterView.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 15/07/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import UIKit

final class StatsHeaderFooterView: UIView {
    
    struct Config {
        let lhsText: String
        let rhsText: String
    }
    
    @IBOutlet private var rhsLabel: UILabel!
    @IBOutlet private var lhsLabel: UILabel!
    
    var lhsText: String = "" {
        didSet {
            lhsLabel.text = lhsText
        }
    }
    
    var rhsText: String = "" {
        didSet {
            rhsLabel.text = rhsText
        }
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
        
        let nibView = Bundle.main.viewFromNib(withType: UIView.self, nibName: "StatsHeaderFooterView", owner: self)
        
        addSubview(nibView)
        nibView.pinToSuperviewEdges()
        
        backgroundColor = .clear
        nibView.backgroundColor = .clear
        
    }
    
}
