//
//  BKDrawerView+Convert.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 04/06/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

extension DrawerView {

    func convertPoint(from dataPoint: CGPoint) -> CGPoint {
        let dx = dataPoint.x - self.dataFrame.minX
        let dy = dataPoint.y - self.dataFrame.minY
        
        let ratioWidth  = self.mainLayer.frame.width / self.dataFrame.width
        let ratioHeight = self.mainLayer.frame.height / self.dataFrame.height
        
        let x = dx * ratioWidth
        let y = dy * ratioHeight
        
        return CGPoint(x: x, y: self.mainLayer.frame.height - y)
    }
    
    
    func convertDataPoint(from point: CGPoint) -> CGPoint {
        let dx = point.x
        let dy = point.y
        
        let ratioWith   = self.dataFrame.width / self.mainLayer.frame.width
        let ratioHeight = self.dataFrame.height / self.mainLayer.frame.height
        
        let x = self.dataFrame.minX + dx * ratioWith
        let y = self.dataFrame.maxY - dy * ratioHeight
        
        return CGPoint(x: x, y: y)
    }
    
    func convertToContenOffset(dataPoint : CGPoint) -> CGPoint {
        let dx = dataPoint.x - self.dataArea.minX
        
        let ratioWidth  = self.scrollView.contentSize.width / self.dataArea.width
        
        let x = dx * ratioWidth
        
        return CGPoint(x: x, y: 0)
    }
}
