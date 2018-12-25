//
//  RoundedPoint.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 29/06/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

public class RoundedPoint: GraphPoint {

    public var fillColor:   UIColor = .blue
    public var strokeColor: UIColor = .white
    
    public var selectedFillColor:   UIColor = .white
    public var selectedStrokeColor: UIColor = .blue
    
    public var radius:          CGFloat = 3.0
    public var selectedRadius:  CGFloat = 3.0
    public var thickness:       CGFloat = 2.0
    
    public override func drawPoint(in graphView: DrawerView) {
        position = graphView.convertPoint(from: CGPoint(x: x, y: y))
        
        let radius = selected ? self.radius : selectedRadius
        
        let path = UIBezierPath(ovalIn: CGRect(x: -radius, y: -radius, width: 2 * radius, height: 2 * radius))
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor    = selected ? selectedFillColor.cgColor : fillColor.cgColor
        shapeLayer.strokeColor  = selected ? selectedStrokeColor.cgColor : strokeColor.cgColor
        shapeLayer.lineWidth    = thickness
    }
}
