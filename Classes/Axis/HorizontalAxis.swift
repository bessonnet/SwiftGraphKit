//
//  BKHorizontalAxis.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 04/06/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit


public enum HorizontalAxisPosition {
    case top
    case bottom
    case topOutside
    case bottomOutside
}

public class HorizontalAxis: CALayer, Axis {
    var axisPosition: HorizontalAxisPosition
    var step: CGFloat
    var height: CGFloat = 30
    
    public var textColor: UIColor = UIColor.black
    public var font: UIFont = UIFont.systemFont(ofSize: 14.0)
    public var axisDelegate: AxisDelegate?
    var pool: LayerPool
    
    public init(step: CGFloat, position: HorizontalAxisPosition = .bottom) {
        self.step = step
        self.axisPosition = position
        self.pool = LayerPool(element: AxisItem(text: ""), step: step)
        super.init()
        
        self.delegate = self
    }
    
    public override init(layer: Any) {
        self.step           = 1
        self.axisPosition   = .bottom
        self.pool = LayerPool(element: AxisItem(text: ""), step: step)
        super.init(layer: layer)
        
        if let axis = layer as? HorizontalAxis {
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
        
        let axisItems = self.pool.elementsBetween(min: graphView.dataFrame.minX - step, max: graphView.dataFrame.maxX + step)
        
        for item in axisItems {
            guard let axisItem = item as? AxisItem else { continue }
            let x = axisItem.index
            
            if axisItem.text == nil {
                axisItem.text = self.axisDelegate?.needStringValue(for: self, at: x) ?? "\(x)"
                axisItem.font = self.font
                axisItem.textColor = self.textColor
            }
            
            let postion = graphView.convertPoint(from: CGPoint(x: x, y: 0))
            axisItem.frame = CGRect(x: 0, y: 0, width: axisItem.size.width, height: 20)
            axisItem.position = CGPoint(x: postion.x, y: self.bounds.height * 0.5)
            
            axisItem.drawAxisItem(in: graphView)
            
            self.addSublayer(axisItem)
        }        
    }
    
    // MARK: - Management
    
    public func removeAllData() {
        self.pool.removeAllData()
    }
}

extension HorizontalAxis: CALayerDelegate {
    
    public func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return NSNull()
    }
}
