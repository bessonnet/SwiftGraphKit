//
//  BreakLineGraph+Gradient.swift
//  SwiftGraphKit
//
//  Created by Charles Bessonnet on 30/01/2019.
//

import UIKit

extension BreakLineGraph {
    
    func drawBackground(path: UIBezierPath, between firstPoint: CGPoint, to lastPoint: CGPoint, in graphView: DrawerView) {
        if haveBackground {
            let maskPath = path
            let minX = firstPoint.x
            let maxX = lastPoint.x
            let minY = graphView.bounds.height
            maskPath.addLine(to: CGPoint(x: maxX, y: minY))
            maskPath.addLine(to: CGPoint(x: minX, y: minY))
            maskPath.addLine(to: firstPoint)
            
            drawGradientBackground(path: maskPath, in: graphView)
        }
    }

    private func drawGradientBackground(path: UIBezierPath, in graphView: DrawerView) {
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath

        gradientLayer.frame = graphView.bounds
        gradientLayer.mask = maskLayer

        insertSublayer(gradientLayer, at: 0)
    }
}
