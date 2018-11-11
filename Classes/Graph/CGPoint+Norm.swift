//
//  GraphPoint+Norm.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 26/07/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

enum BKNorm {
    case quadratic
    case absisse
}

extension CGPoint {

    func distance(to point: CGPoint, norm: BKNorm, dataFrame: CGRect?) -> CGFloat {
        
        switch norm {
        case .quadratic:
            guard let frame = dataFrame else { return 0 }
            // using formula of normalize distance to avoid strange case of use (due to huge varation on one axis)
            let dx = (self.x - point.x) / frame.width
            let dy = (self.y - point.y) / frame.height
            let distance = dx * dx + dy * dy
            return distance
        case .absisse:
            return abs(self.x - point.x)
        }
    }
}
