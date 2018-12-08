//
//  Graph+Function.swift
//  SwiftGraphKit
//
//  Created by Charles Bessonnet on 08/12/2018.
//

import UIKit

public typealias Function = (CGFloat) -> CGFloat?

extension Graph {

    public convenience init(function: @escaping Function, step: CGFloat, defaultPoint: GraphPoint) {
        self.init()
        
        self.function       = function
        self.stepFunction   = step
        self.basePoint      = defaultPoint
    }
    
    func fetchRequiredPointsWithFunction(between min: CGFloat, to max: CGFloat) {
        guard let step = stepFunction, let function = function, let point = basePoint else { return }
        
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
    }
}
