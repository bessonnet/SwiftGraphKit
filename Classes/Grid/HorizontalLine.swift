//
//  HorizontalLine.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 28/05/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

class HorizontalLine: CALayer, CALayerDelegate {
    var index: CGFloat
    var color: UIColor = UIColor.lightGray
    
    private var lineLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 1.0
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    init(y: CGFloat) {
        self.index = y
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
        
        var leftPoint = graphView.convertPoint(from: CGPoint(x: 0, y: self.index))
        leftPoint.x = 0
        let righPoint = CGPoint(x: graphView.bounds.width, y: leftPoint.y)
        
        let path = UIBezierPath()
        path.move(to: leftPoint)
        path.addLine(to: righPoint)
        
        self.lineLayer.strokeColor = self.color.cgColor
        self.lineLayer.path = path.cgPath
    }
    
    // MARK: - CALayerDelegate
    
    public func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return NSNull()
    }
}

extension HorizontalLine: OrdonableLayer {
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = HorizontalLine(y: 0)
        copy.index = self.index
        return copy
    }
}
