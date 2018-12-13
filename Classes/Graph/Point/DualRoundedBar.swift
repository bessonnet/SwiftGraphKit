//
//  RoundedBar.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 01/08/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

public class DualRoundedBar: GraphPoint {
    public var minY: CGFloat
    public var maxY: CGFloat
    
    public var width: CGFloat = 10
    
    public var topColor    = UIColor.green
    public var bottomColor = UIColor.red
    
    var topBar      = CAShapeLayer()
    var bottomBar   = CAShapeLayer()
    
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
        
        self.topBar.delegate    = self
        self.bottomBar.delegate = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func drawPoint(in graphView: DrawerView) {
        self.drawTopBar(in: graphView)
        self.drawBottomBar(in: graphView)
    }
    
    func drawTopBar(in graphView: DrawerView) {
        guard self.maxY > 0 else { return }
        
        let bottom = graphView.convertPoint(from: CGPoint(x: self.x, y: 0))
        let top    = graphView.convertPoint(from: CGPoint(x: self.x, y: self.maxY))
        
        let path = UIBezierPath()
        
        // draw arc of circle
        
        let center = CGPoint(x: top.x, y: top.y - self.width/2)
        path.addArc(withCenter: center, radius: self.width/2, startAngle: 0, endAngle: .pi, clockwise: false)
        
        // draw rect
        
        let b1 = CGPoint(x: bottom.x - self.width/2, y: bottom.y)
        let b2 = CGPoint(x: bottom.x + self.width/2, y: bottom.y)
        path.addLine(to: b1)
        path.addLine(to: b2)
        
        let t2 = CGPoint(x: top.x + self.width/2, y: top.y - self.width/2)
        path.addLine(to: t2)
        
        self.topBar.path = path.cgPath
        self.topBar.fillColor = self.topColor.cgColor

        if self.topBar.superlayer == nil {
            self.shapeLayer.addSublayer(self.topBar)
        }
    }
    
    func drawBottomBar(in graphView: DrawerView) {
        guard self.minY < 0 else { return }
        
        let bottom = graphView.convertPoint(from: CGPoint(x: self.x, y: 0))
        let top    = graphView.convertPoint(from: CGPoint(x: self.x, y: self.minY))
        
        let path = UIBezierPath()
        
        // draw arc of circle
        
        let center = CGPoint(x: top.x, y: top.y - self.width/2)
        path.addArc(withCenter: center, radius: self.width/2, startAngle: .pi, endAngle: 2 * .pi, clockwise: false)
        
        // draw rect
        
        let b1 = CGPoint(x: bottom.x - self.width/2, y: bottom.y)
        let b2 = CGPoint(x: bottom.x + self.width/2, y: bottom.y)
        
        path.addLine(to: b2)
        path.addLine(to: b1)
        
        let t1 = CGPoint(x: top.x - self.width/2, y: top.y - self.width/2)
        path.addLine(to: t1)
        
        self.bottomBar.path = path.cgPath
        self.bottomBar.fillColor = self.bottomColor.cgColor
        
        if self.bottomBar.superlayer == nil {
            self.shapeLayer.addSublayer(self.bottomBar)
        }
    }
}
