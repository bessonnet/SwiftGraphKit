//
//  BKBezierGraph+Gradient.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 30/07/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

extension BezierGraph {

    func drawGradientBackground(path: UIBezierPath, in graphView: DrawerView) {    
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        
        gradientLayer.frame = graphView.bounds
        gradientLayer.mask = maskLayer
        
        insertSublayer(gradientLayer, at: 0)
    }
}
