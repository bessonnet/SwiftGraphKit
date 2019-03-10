//
//  VerticalLine.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 28/05/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

class VerticalLine: CALayer {
    var index: CGFloat
    var color: UIColor = UIColor.lightGray
    
    private var lineLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 1.0
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    init(x: CGFloat) {
        self.index = x
        super.init()
        self.lineLayer.delegate = self
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawGraph(in graphView: DrawerView) {
        if self.sublayers ==  nil {
            self.addSublayer(self.lineLayer)
        }
        
        var bottomPoint = graphView.convertPoint(from: CGPoint(x: self.index, y: 0))
        bottomPoint.y = 0
        let topPoint = CGPoint(x: bottomPoint.x, y: graphView.bounds.height)
        
        let path = UIBezierPath()
        path.move(to: bottomPoint)
        path.addLine(to: topPoint)
        
        self.lineLayer.strokeColor = self.color.cgColor
        self.lineLayer.path = path.cgPath
    }
}
    
extension VerticalLine: CALayerDelegate {
    
    public func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return NSNull()
    }
}

extension VerticalLine: OrdonableLayer {
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = VerticalLine(x: 0)
        copy.index = self.index
        return copy
    }
}
