//
//  BKZoomManager.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 27/07/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

class BKZoomManager {
    var allowsZooming = false
    
    /// centroid of gesture on begin (on unit of graph)
    private var center: CGPoint = .zero
    private var originDataFrame: CGRect = .zero
    
    func beginZoom(point: CGPoint, dataFrame: CGRect) {
        self.center = point
        self.originDataFrame = dataFrame
    }
    
    func targetFrame(scaleFactor: CGFloat) -> CGRect {
        let width = scaleFactor * self.originDataFrame.width
        let x = originDataFrame.midX - width/2
        
        return CGRect(x: x, y: self.originDataFrame.minY, width: width, height: self.originDataFrame.height)
    }
}
