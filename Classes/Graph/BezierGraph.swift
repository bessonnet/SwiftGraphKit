//
//  BezierGraph.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 17/07/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

public class BezierGraph: Graph {
    public var color: UIColor = UIColor.blue.withAlphaComponent(0.4)
    public var gradientColors: [UIColor]? = nil {
        didSet {
            self.gradientLayer.colors = gradientColors?.compactMap({ $0.cgColor })
        }
    }
    public var thickness: CGFloat = 3.0
    
    private var breakLineShape: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        return gradientLayer
    }()
    
    // MARK: - Init
    
    public override init() {
        super.init()
        
        self.breakLineShape.delegate = self
        self.gradientLayer.delegate  = self
    }
    
    public override init(function: @escaping Function, step: CGFloat, defaultPoint: GraphPoint) {
        super.init(function: function, step: step, defaultPoint: defaultPoint)
        
        self.breakLineShape.delegate = self
        self.gradientLayer.delegate  = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Draw
    
    override func drawGraph(in graphView: DrawerView) {
        self.sublayers = nil
        
        self.drawCurve(in: graphView)
        self.drawPoints(in: graphView)
    }
    
    private func drawCurve(in graphView: DrawerView) {
        let curvePoints = self.needPoints(in: graphView)
        guard curvePoints.count > 1 else { return }
        
        let points = curvePoints.compactMap({ graphView.convertPoint(from: $0.point) })
        
        let path = self.curve(points: points)
        
        self.breakLineShape.lineWidth   = self.thickness
        self.breakLineShape.strokeColor = self.color.cgColor
        
        self.breakLineShape.path = path.cgPath
        self.addSublayer(self.breakLineShape)
        
        
        // Draw gradient
        if self.gradientColors != nil {
            let maskPath = path
            if let initPoint = points.first, let minX = points.first?.x, let maxX = points.last?.x {
                let minY = graphView.bounds.height
                maskPath.addLine(to: CGPoint(x: maxX, y: minY))
                maskPath.addLine(to: CGPoint(x: minX, y: minY))
                maskPath.addLine(to: initPoint)
            }
            
            self.drawGradientBackground(path: maskPath, in: graphView)
        }
    }
    
    func needPoints(in graphView: DrawerView) -> [GraphPoint] {
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
