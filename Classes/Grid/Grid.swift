//
//  Grid.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 28/05/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

public class Grid: CALayer {
    var stepX: CGFloat = 1
    var stepY: CGFloat = 1
    public var color: UIColor = UIColor.lightGray
    
    var verticalPool: LayerPool
    var horizontalPool: LayerPool
    
    // MARK: - Init
    
    public init(stepX: CGFloat, stepY: CGFloat) {
        self.stepX = stepX
        self.stepY = stepY
        
        self.verticalPool = LayerPool(element: VerticalLine(x: 0), step: stepX)
        self.horizontalPool = LayerPool(element: HorizontalLine(y: 0), step: stepY)
        
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Draw
    
    func drawGraph(in graphView: DrawerView) {
        self.sublayers = nil
        
        // Draw vertical line
        
        let verticalItems = self.verticalPool.elementsBetween(min: graphView.dataFrame.minX - stepX, max: graphView.dataFrame.maxX + stepX)
        
        for item in verticalItems {
            guard let verticalLine = item as? VerticalLine else { continue }
            verticalLine.color = self.color
            self.addSublayer(verticalLine)
            verticalLine.drawGraph(in: graphView)
        }
        
        // Draw horizontal line
        
        let horizontalItems = self.horizontalPool.elementsBetween(min: graphView.dataFrame.minY - stepY, max: graphView.dataFrame.maxY + stepY)
        
        for item in horizontalItems {
            guard let horizontalLine = item as? HorizontalLine else { continue }
            horizontalLine.color = self.color
            self.addSublayer(horizontalLine)
            horizontalLine.drawGraph(in: graphView)
        }
    }
    
    // MARK: - Manage line
    
    private func neededVerticalLine(in graphView: DrawerView) -> [CGFloat] {
        let minX = graphView.dataFrame.minX - stepX
        let maxX = graphView.dataFrame.maxX + stepX
        
        return self.valueBetween(min: minX, max: maxX, step: stepX)
    }
    
    private func neededHorizontalLine(in graphView: DrawerView) -> [CGFloat] {
        let minY = graphView.dataFrame.minY - stepY
        let maxY = graphView.dataFrame.maxY + stepY
        
        return self.valueBetween(min: minY, max: maxY, step: stepY)
    }
    
    // MARK: - Helpers
    
    private func valueBetween(min: CGFloat, max: CGFloat, step: CGFloat) -> [CGFloat] {
        var result = [CGFloat]()
        
        let first = floor(min / step) * step
        result.append(first)
        
        var current = first
        while current < max {
            current = current + step
            result.append(current)
        }
        
        return result
    }
}
