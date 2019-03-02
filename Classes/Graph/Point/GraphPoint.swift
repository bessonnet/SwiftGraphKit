//
//  GKPoint.swift
//  GraphView
//
//  Created by Charles Bessonnet on 17/08/2017.
//  Copyright © 2017 Charles Bessonnet. All rights reserved.
//

import UIKit

public class GraphPoint: CALayer, CALayerDelegate {
    public var x: CGFloat
    public var y: CGFloat
    public var selected: Bool = false
    
    public var color: UIColor = .blue
    
    var min: CGFloat {
        return y
    }
    var max: CGFloat {
        return y
    }
    
    /// point represent position of GraphPoint on dataFrame (unit = unit of graph)
    public var point: CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    /// rect is rectangle that contains draw of point on screen (unit = pixel)
    public var rect: CGRect = .zero
    
    public var shapeLayer = CAShapeLayer()
        
    //MARK: Object lifecycle
    
    public init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
        
        super.init()
        
        addSublayer(shapeLayer)
        shapeLayer.delegate = self
        delegate = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(layer: Any) {
        x = 0
        y = 0
        
        super.init(layer: layer)
    }
    
    
    // MARK: - Drawing methods
    
    public func prepareDraw(in graphView: DrawerView) {
        position = graphView.convertPoint(from: CGPoint(x: x, y: y))
        rect = CGRect(x: position.x - 2, y: position.y - 2, width: 4, height: 4)
    }
    
    public func drawPoint(in graphView: DrawerView) {
        let path = UIBezierPath(ovalIn: CGRect(x: -2, y: -2, width: 4, height: 4))
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = color.cgColor
    }
    
    
    // MARK: - Helpers
    
    public func isVisible(inDataFrame frame: CGRect) -> Bool {
        return frame.contains(CGPoint(x: x, y: y))
    }
    
    public func isVisible(inFrame frame: CGRect) -> Bool {
        return frame.intersects(rect)
    }
    
    // MARK: - CALayerDelegate
    
    public func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return NSNull()
    }
}

extension GraphPoint: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        let copy = GraphPoint(x: x, y: y)
        copy.color = color
        return copy
    }
}
