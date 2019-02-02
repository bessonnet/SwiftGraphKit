//
//  BezierGraph.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 17/07/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

public class BezierGraph: BreakLineGraph {
    
    
    // MARK: - Draw
    
    override func drawGraph(in graphView: DrawerView) {
        sublayers = nil
        
        drawCurve(in: graphView)
        drawPoints(in: graphView)
    }
    
    private func drawCurve(in graphView: DrawerView) {
        let curvePoints = self.needPoints(in: graphView)
        guard curvePoints.count > 1 else { return }
        
        let points = curvePoints.compactMap({ graphView.convertPoint(from: $0.point) })
        
        let path = self.curve(points: points)
        
        breakLineShape.lineWidth   = thickness
        breakLineShape.strokeColor = color.cgColor
        
        breakLineShape.path = path.cgPath
        addSublayer(self.breakLineShape)
        
        
        // Draw background of graph base of path
        if let first = points.first, let last = points.last {
            drawBackground(path: path, between: first, to: last, in: graphView)
        }
    }
    
    override func needPoints(in graphView: DrawerView) -> [GraphPoint] {
        guard let firstVisiblePoint = points.first(where: { $0.isVisible(inFrame: graphView.dataFrame)}) else { return [GraphPoint]() }
        guard let lastVisiblePoint = points.reversed().first(where: { $0.isVisible(inFrame: graphView.dataFrame)}) else { return [GraphPoint]() }
        
        let firstIndex = max(0, (points.index(of: firstVisiblePoint) ?? 0) - 2)
        let lastIndex  = max(points.count, (points.index(of: lastVisiblePoint) ?? 0) + 1)
        
        var result = [GraphPoint]()
        
        for i in firstIndex..<lastIndex {
            let point = points[i]
            result.append(point)
        }
        
        return result
    }
    
    // MARK: - Curve
    
    private func curve(points: [CGPoint]) -> UIBezierPath {
        let path = UIBezierPath()
        
        // calculate derivation
        var derivate = [CGPoint]()
        
        for j in 0..<points.count {
            let previous    = points[max(0, j-1)]
            let next        = points[min(j+1, points.count-1)]
            
            let derivePoint = CGPoint(x: (next.x - previous.x) / 2, y: (next.y - previous.y) / 2)
            derivate.append(derivePoint)
        }
        
        // calculate paths (using derivation)
        
        let tension: CGFloat = 5.0
        
        for i in 0..<points.count {
            if i == 0 {
                path.move(to: points[i])
            } else {
                let endPoint = points[i]
                
                let cp1_x = points[i-1].x + (derivate[i-1].x / tension)
                let cp1_y = points[i-1].y + (derivate[i-1].y / tension)
                let cp1 = CGPoint(x: cp1_x, y: cp1_y)
                
                
                let cp2_x = points[i].x - (derivate[i].x / tension)
                let cp2_y = points[i].y - (derivate[i].y / tension)
                let cp2 = CGPoint(x: cp2_x, y: cp2_y)
                
                path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
            }
        }
        
        return path
    }
}
