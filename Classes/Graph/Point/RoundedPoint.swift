//
//  RoundedPoint.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 29/06/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

public class RoundedPoint: GraphPoint {

    public var fillColor:   UIColor = UIColor.blue
    public var strokeColor: UIColor = UIColor.blue
    
    public var selectedColor: UIColor = UIColor.white
    
    public var radius: CGFloat      = 3.0
    public var thickness: CGFloat   = 2.0
    
    public override func drawPoint(in graphView: DrawerView) {
        position = graphView.convertPoint(from: CGPoint(x: x, y: y))
        
        let path = UIBezierPath(ovalIn: CGRect(x: -self.radius, y: -self.radius, width: 2 * self.radius, height: 2 * self.radius))
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor    = self.selected ? self.selectedColor.cgColor :self.fillColor.cgColor
        shapeLayer.strokeColor  = self.strokeColor.cgColor
        shapeLayer.lineWidth    = self.thickness
    }
}
