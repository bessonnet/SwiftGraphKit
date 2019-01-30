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

        self.gradientLayer.frame = graphView.bounds
        self.gradientLayer.mask = maskLayer

        self.insertSublayer(self.gradientLayer, at: 0)
    }
}
