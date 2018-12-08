//
//  Graph+Function.swift
//  SwiftGraphKit
//
//  Created by Charles Bessonnet on 08/12/2018.
//

import UIKit

public typealias Function = (CGFloat) -> CGFloat?

public extension Graph {
    
    func fetchRequiredPointsWithFunction(in graphView: DrawerView, between min: CGFloat, to max: CGFloat) {
        print("try draw")
        guard let step = stepFunction, let function = function else { return }
        
        let values = CGFloat.valueBetween(min: min, max: max, step: step)
        
        for x in values {
            
            var points = [GraphPoint]()
            
            if let y = function(x), let point = basePoint?.copy() as? GraphPoint {
                point.x = x
                point.y = y
                
                points.append(point)
            }
            
            addData(data: points)
        }
        print("draw: new point :\(points) - (\(min) - \(max))")
        graphView.forceToRedraw = true
    }
}
