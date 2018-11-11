//
//  Grid+AutoResize.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 01/06/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

extension Grid {

    public static func adjust(height: CGFloat, numberOfLineWanted: Int) -> CGFloat {
        var stepPossible: [CGFloat] = [1, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 25000, 50000, 100000]
        
        var step    = stepPossible[0]
        var numberOfLine   = height / step
        
        for i in 1..<stepPossible.count {
            let currentNumberOfLine = height / stepPossible[i]
            
            if abs(currentNumberOfLine - CGFloat(numberOfLineWanted)) < abs(numberOfLine - CGFloat(numberOfLineWanted)) {
                
                step = stepPossible[i]
                numberOfLine = currentNumberOfLine
            }
        }
        
        return step
    }
}
