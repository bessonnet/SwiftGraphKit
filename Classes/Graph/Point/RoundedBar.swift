//
//  RoundedBar.swift
//  SwiftGraphKit
//
//  Created by Charles Bessonnet on 13/12/2018.
//

import UIKit

public class RoundedBar: GraphPoint {
    public var minY: CGFloat
    public var maxY: CGFloat
    
    public var width: CGFloat   = 10
    public var radius: CGFloat  = 2
    
    var bar = CAShapeLayer()
    
    override var min: CGFloat {
        return minY
    }
    override var max: CGFloat {
        return maxY
    }
    
    public init(x: CGFloat, minY: CGFloat, maxY: CGFloat) {
        self.minY = minY
        self.maxY = maxY
        
        super.init(x: x, y: 0)
        
        self.bar.delegate = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func drawPoint(in graphView: DrawerView) {
        
        let bottom = graphView.convertPoint(from: CGPoint(x: self.x, y: self.minY))
        let top    = graphView.convertPoint(from: CGPoint(x: self.x, y: self.maxY))
        
        let y       = top.y
        let x       = bottom.x - width/2
        let height  = bottom.y - top.y
        
        let rect = CGRect(x: x, y: y, width: width, height: height)
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        
        self.bar.path = path.cgPath
        self.bar.fillColor = color.cgColor
        
        if self.bar.superlayer == nil {
            self.shapeLayer.addSublayer(self.bar)
        }
    }
}
