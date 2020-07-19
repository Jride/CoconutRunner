//
//  DequeuableTableViewCell.swift
//  CoconutBasket
//
//  Created by Josh Rideout on 13/07/2020.
//  Copyright © 2020 JoshRideout. All rights reserved.
//

import Foundation
import UIKit

protocol DequeuableTableViewCell: class {
    @nonobjc static var nibName: String? {get}
}

fileprivate extension DequeuableTableViewCell {
    @nonobjc static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    
    func register<T: DequeuableTableViewCell>(dequeuableCellType: T.Type) {
        
        if let nibName = dequeuableCellType.nibName {
            let nib = UINib(nibName: nibName, bundle: nil)
            register(nib, forCellReuseIdentifier: dequeuableCellType.reuseIdentifier)
        } else {
            register(dequeuableCellType, forCellReuseIdentifier: dequeuableCellType.reuseIdentifier)
        }
    }
    
    func dequeue<T: DequeuableTableViewCell>(dequeableCellType: T.Type, indexPath: IndexPath) -> T {
        
        guard let cell = self.dequeueReusableCell(withIdentifier: dequeableCellType.reuseIdentifier) as? T else {
            fatalError("Unable to dequeue cell")
        }
        return cell
    }
}
