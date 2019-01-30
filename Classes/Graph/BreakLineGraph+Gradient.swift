//
//  BreakLineGraph+Gradient.swift
//  SwiftGraphKit
//
//  Created by Charles Bessonnet on 30/01/2019.
//

import UIKit

extension BreakLineGraph {

    func drawGradientBackground(path: UIBezierPath, in graphView: DrawerView) {
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath

        gradientLayer.frame = graphView.bounds
        gradientLayer.mask = maskLayer

        insertSublayer(gradientLayer, at: 0)
    }
}
