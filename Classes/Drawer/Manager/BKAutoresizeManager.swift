//
//  BKAutoresizeManager.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 18/07/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

class BKAutoresizeManager {
    static let AnimationDelay: TimeInterval = 0.5
    
    var allowsAutoresize: Bool = false
    var autoresizeTimestamp: TimeInterval?
    var autoresizeOriginFrame: CGRect
    var autoresizeTargetFrame: CGRect
    
    init(dataFrame: CGRect) {
        autoresizeOriginFrame = dataFrame
        autoresizeTargetFrame = dataFrame
    }
    
    func calculateDataFrame(to targetDataFrame: CGRect, dataFrame: CGRect, timestamp: TimeInterval) -> CGRect {
        
        if self.resetAnimation(targetDataFrame: targetDataFrame, dataFrame: self.autoresizeTargetFrame) {
            self.autoresizeTimestamp    = timestamp
            self.autoresizeTargetFrame  = targetDataFrame
            self.autoresizeOriginFrame  = dataFrame
            return dataFrame
        } else {
            guard let begin = self.autoresizeTimestamp else { return dataFrame }
            let delay = timestamp - begin
            let avancement = CGFloat(min(delay / BKAutoresizeManager.AnimationDelay, 1.0))
            
            let minY = autoresizeOriginFrame.minY + (autoresizeTargetFrame.minY - autoresizeOriginFrame.minY) * avancement
            let height = autoresizeOriginFrame.height + (autoresizeTargetFrame.height - autoresizeOriginFrame.height) * avancement
            
            return CGRect(x: dataFrame.minX, y: minY, width: dataFrame.width, height: height)
        }
    }
    
    private func resetAnimation(targetDataFrame: CGRect, dataFrame: CGRect) -> Bool {
        return targetDataFrame.minY != dataFrame.minY || targetDataFrame.height != dataFrame.height
    }
}
