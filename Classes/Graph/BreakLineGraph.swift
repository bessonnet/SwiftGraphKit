//
//  GKBreakLineGraph.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 28/05/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

public class BreakLineGraph: Graph {
    public var color: UIColor = UIColor.blue.withAlphaComponent(0.4)
    
    public var graphBackground: GraphBackground?
    public var thickness: CGFloat = 3.0
    
    var breakLineShape: CAShapeLayer = {
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
        
        breakLineShape.delegate = self
        gradientLayer.delegate  = self
    }
    
    public override init(function: @escaping Function, step: CGFloat, defaultPoint: GraphPoint) {
        super.init(function: function, step: step, defaultPoint: defaultPoint)
        
        breakLineShape.delegate = self
        gradientLayer.delegate  = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Draw

    override func drawGraph(in graphView: DrawerView) {
        sublayers = nil
        
        drawBreakLine(in: graphView)
        drawPoints(in: graphView)
    }
    
    func drawBreakLine(in graphView: DrawerView) {
        let curvePoints = self.needPoints(in: graphView)        
        let points = curvePoints.compactMap({ graphView.convertPoint(from: $0.point) })
        guard let firstPoint = points.first else { return }
        
        let path = UIBezierPath()
        path.move(to: firstPoint)
        
        for i in 1..<curvePoints.count {
            path.addLine(to: points[i])
        }
        
        breakLineShape.lineWidth   = thickness
        breakLineShape.strokeColor = color.cgColor
        
        breakLineShape.path = path.cgPath
        addSublayer(breakLineShape)
        
        // Draw background of graph base of path
        if let first = points.first, let last = points.last {
            drawBackground(path: path, between: first, to: last, in: graphView)
        }
    }
    
    func needPoints(in graphView: DrawerView) -> [GraphPoint] {
        guard let firstVisiblePoint = points.first(where: { $0.isVisible(inDataFrame: graphView.dataFrame)}) else { return [GraphPoint]() }
        guard let lastVisiblePoint = points.reversed().first(where: { $0.isVisible(inDataFrame: graphView.dataFrame)}) else { return [GraphPoint]() }
        
        let firstIndex = max(0, (points.firstIndex(of: firstVisiblePoint) ?? 0) - 1)
        let lastIndex  = max(points.count, (points.firstIndex(of: lastVisiblePoint) ?? 0) + 1)
        
        var result = [GraphPoint]()
        
        for i in firstIndex..<lastIndex {
            let point = points[i]
            result.append(point)
        }
        
        return result
    }
}
