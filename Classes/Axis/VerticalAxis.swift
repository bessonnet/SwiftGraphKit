//
//  BKVerticalAxis.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 04/06/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

public enum VerticalAxisPosition {
    case left
    case right
    case rightOutside
    case leftOutside
}

public class VerticalAxis: CALayer, Axis {
    var axisPosition: VerticalAxisPosition
    var step: CGFloat
    var width: CGFloat = 30
    
    public var textColor: UIColor = UIColor.black
    public var font: UIFont = UIFont.systemFont(ofSize: 14.0)
    public var axisDelegate: AxisDelegate?
    var pool: LayerPool
    
    public init(step: CGFloat, position: VerticalAxisPosition = .left) {
        self.step = step
        self.axisPosition = position
        self.pool = LayerPool(element: AxisItem(text: ""), step: step)
        super.init()
        
        self.delegate = self
    }
    
    public override init(layer: Any) {
        self.step           = 1
        self.axisPosition   = .left
        self.pool = LayerPool(element: AxisItem(text: ""), step: step)
        super.init(layer: layer)
        
        if let axis = layer as? VerticalAxis {
            self.step = axis.step
            self.axisPosition = axis.axisPosition
            self.pool.step = axis.step
        }
        
        self.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Draw
    
    public func drawAxis(graphView: DrawerView) {
        self.sublayers = nil
        
        let axisItems = self.pool.elementsBetween(min: graphView.dataFrame.minY - step, max: graphView.dataFrame.maxY + step)
        
        for item in axisItems {
            guard let axisItem = item as? AxisItem else { continue }
            let y = axisItem.index
            let postion = graphView.convertPoint(from: CGPoint(x: 0, y: y))
            axisItem.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            axisItem.position = CGPoint(x:  self.bounds.width * 0.5, y: postion.y)
            
            if axisItem.text == nil {
                axisItem.text = self.axisDelegate?.needStringValue(for: self, at: y) ?? "\(y)"
                axisItem.font = self.font
                axisItem.textColor = self.textColor
            }
            
            if self.bounds.contains(axisItem.frame) {
                axisItem.drawAxisItem(in: graphView)
                self.addSublayer(axisItem)
            }
        }
    }
    
    // MARK: - Management
    
    public func removeAllData() {
        self.pool.removeAllData()
    }
}

extension VerticalAxis: CALayerDelegate {
    
    public func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return NSNull()
    }
}
