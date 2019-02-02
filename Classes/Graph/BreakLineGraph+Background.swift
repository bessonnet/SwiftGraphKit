//
//  BreakLineGraph+Gradient.swift
//  SwiftGraphKit
//
//  Created by Charles Bessonnet on 30/01/2019.
//

import UIKit

extension BreakLineGraph {
    
    func drawBackground(path: UIBezierPath, between firstPoint: CGPoint, to lastPoint: CGPoint, in graphView: DrawerView) {
        guard let background = graphBackground else { return }
        
        if background.haveBackground == true {
            let maskPath = path
            let minX = firstPoint.x
            let maxX = lastPoint.x
            let minY = graphView.bounds.height
            
            if background.cornerRadius > 0 {
                let y = minY - background.cornerRadius
                
                maskPath.addLine(to: CGPoint(x: maxX, y: y))
                
                let c1 = CGPoint(x: maxX - background.cornerRadius, y: y)
                maskPath.addArc(withCenter: c1, radius: background.cornerRadius, startAngle: 0, endAngle: .pi/2, clockwise: true)
                
                maskPath.addLine(to: CGPoint(x: minX + background.cornerRadius, y: minY))
                
                let c2 = CGPoint(x: minX + background.cornerRadius, y: y)
                maskPath.addArc(withCenter: c2, radius: background.cornerRadius, startAngle: .pi/2, endAngle: .pi, clockwise: true)
                
                maskPath.addLine(to: firstPoint)
            } else {
                maskPath.addLine(to: CGPoint(x: maxX, y: minY))
                maskPath.addLine(to: CGPoint(x: minX, y: minY))
                maskPath.addLine(to: firstPoint)
            }
            
            drawGradientBackground(path: maskPath, in: graphView)
        }
    }

    private func drawGradientBackground(path: UIBezierPath, in graphView: DrawerView) {
        guard let colorRefs = graphBackground?.colorRefs else { return }
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath

        gradientLayer.colors = colorRefs
        gradientLayer.frame = graphView.bounds
        gradientLayer.mask = maskLayer
        gradientLayer.cornerRadius = graphBackground?.cornerRadius ?? 0
        
        insertSublayer(gradientLayer, at: 0)
    }
}
