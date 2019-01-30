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
        self.sublayers = nil
        
        self.drawBreakLine(in: graphView)
        self.drawPoints(in: graphView)
    }
    
    private func drawBreakLine(in graphView: DrawerView) {
        let curvePoints = self.needPoints(in: graphView)        
        let points = curvePoints.compactMap({ graphView.convertPoint(from: $0.point) })
        guard let firstPoint = points.first else { return }
        
        let path = UIBezierPath()
        path.move(to: firstPoint)
        
        for i in 1..<curvePoints.count {
            path.addLine(to: points[i])
        }
        
        self.breakLineShape.lineWidth   = self.thickness
        self.breakLineShape.strokeColor = self.color.cgColor
        
        self.breakLineShape.path = path.cgPath
        self.addSublayer(self.breakLineShape)
        
        // Draw gradient
        if self.gradientColors != nil {
            let maskPath = path
            if let minX = points.first?.x, let maxX = points.last?.x {
                let minY = graphView.bounds.height
                maskPath.addLine(to: CGPoint(x: maxX, y: minY))
                maskPath.addLine(to: CGPoint(x: minX, y: minY))
                maskPath.addLine(to: firstPoint)
            }
            
            self.drawGradientBackground(path: maskPath, in: graphView)
        }
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
