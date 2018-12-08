//
//  Maths.swift
//  SwiftGraphKit
//
//  Created by Charles Bessonnet on 08/12/2018.
//

import UIKit

extension CGFloat {

    static func valueBetween(min: CGFloat, max: CGFloat, step: CGFloat) -> [CGFloat] {
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
