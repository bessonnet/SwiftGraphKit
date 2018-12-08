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
    public var thickness: CGFloat = 3.0
    
    private var breakLineShape: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    // MARK: - Init
    
    public override init() {
        super.init()
        
        self.breakLineShape.delegate = self
    }
    
    public override init(function: @escaping Function, step: CGFloat, defaultPoint: GraphPoint) {
        super.init(function: function, step: step, defaultPoint: defaultPoint)
        
        self.breakLineShape.delegate = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Draw

    override func drawGraph(in graphView: DrawerView) {
        self.sublayers = nil
        
        self.drawBreakLine(in: graphView)
        self.drawPoints(in: graphView)
    }
    
    private func drawBreakLine(in graphView: DrawerView) {
        let curvePoints = self.needPoints(in: graphView)
        guard let firstPoint = curvePoints.first else { return }
        
        let path = UIBezierPath()
        path.move(to: graphView.convertPoint(from: firstPoint.point))
        
        for i in 1..<curvePoints.count {
            let point = curvePoints[i]
            path.addLine(to: graphView.convertPoint(from: point.point))
        }
        
        self.breakLineShape.lineWidth   = self.thickness
        self.breakLineShape.strokeColor = self.color.cgColor
        
        self.breakLineShape.path = path.cgPath
        self.addSublayer(self.breakLineShape)
    }
    
    func needPoints(in graphView: DrawerView) -> [GraphPoint] {
        guard let firstVisiblePoint = points.first(where: { $0.isVisible(inFrame: graphView.dataFrame)}) else { return [GraphPoint]() }
        guard let lastVisiblePoint = points.reversed().first(where: { $0.isVisible(inFrame: graphView.dataFrame)}) else { return [GraphPoint]() }
        
        let firstIndex = max(0, (points.index(of: firstVisiblePoint) ?? 0) - 1)
        let lastIndex  = max(points.count, (points.index(of: lastVisiblePoint) ?? 0) + 1)
        
        var result = [GraphPoint]()
        
        for i in firstIndex..<lastIndex {
            let point = points[i]
            result.append(point)
        }
        
        return result
    }
}
