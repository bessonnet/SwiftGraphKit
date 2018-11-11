//
//  BKDrawerView+Autoresize.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 18/07/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

extension DrawerView {

    func updateDataFrameForAutoresize(timestamp: TimeInterval) {
        guard self.autoresizeManager.allowsAutoresize else { return }
        
        let targetFrame = self.calculateTargetFrame()
        
        self.dataFrame = self.autoresizeManager.calculateDataFrame(to: targetFrame, dataFrame: self.dataFrame, timestamp: timestamp)
    }
    
    private func calculateTargetFrame() -> CGRect {
        let dataFrame = self.dataFrame
        
        // add some margin to be less sensible to variation on scroll
        let marginRatio: CGFloat = 0.2
        let x = dataFrame.minX - marginRatio * dataFrame.width
        let width = (1 + 2 * marginRatio) * dataFrame.width
        let pointFrame = CGRect(x: x, y: dataFrame.minY, width: width , height: dataFrame.height)
        
        
        // calculate min max for portion of graph
        
        var min = CGFloat.greatestFiniteMagnitude
        var max = CGFloat.leastNormalMagnitude
        
        for graph in self.graphs {
            let (currentMin, currentMax) = graph.minMax(dataFrame: pointFrame)
            
            if currentMin < min {
                min = currentMin
            }
            
            if currentMax > max {
                max = currentMax
            }
        }
        
        // generate target data frame
        
        if min == CGFloat.greatestFiniteMagnitude || max == CGFloat.leastNormalMagnitude || max == min {
            return self.dataFrame
        } else {
            let marginRatio: CGFloat = 0.1
            let heigth = max - min
            let adaptedHeight = heigth * (1 + 2 * marginRatio)
            let minY = min - marginRatio * heigth
            
            return CGRect(x: dataFrame.minX, y: minY, width: dataFrame.width, height: adaptedHeight)
        }
    }
}
