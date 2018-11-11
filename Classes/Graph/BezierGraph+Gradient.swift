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
        
        self.gradientLayer.frame = graphView.bounds
        self.gradientLayer.mask = maskLayer
        
        self.insertSublayer(self.gradientLayer, at: 0)
    }
}
