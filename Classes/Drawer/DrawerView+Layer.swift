//
//  BKDrawer+Layer.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 28/06/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

extension DrawerView {
    
    func updateLayerFrame() {
        self.updateFrameOfMainLayer()
        self.updateFrameOfHorizontalAxis()
        self.updateFrameOfVerticalAxis()
    }

    private func updateFrameOfMainLayer() {
        var x: CGFloat = 0
        if let axis = self.horizontalAxis, axis.axisPosition == .topOutside {
            x = axis.height
        }
        var y: CGFloat = 0
        if let axis = self.verticalAxis, axis.axisPosition == .leftOutside {
            y = axis.width
        }
        
        var width = self.layer.frame.width
        if let axis = self.verticalAxis {
            switch axis.axisPosition {
            case .left, .right:
                width = self.layer.frame.width
            case .rightOutside, .leftOutside:
                width = self.layer.frame.width - axis.width
            }
        }
        
        var height = self.layer.frame.height
        if let axis = self.horizontalAxis {
            switch axis.axisPosition {
            case .top, .bottom:
                height = self.layer.frame.height
            case .topOutside, .bottomOutside:
                height = self.layer.frame.height - axis.height
            }
        }
        
        self.mainLayer.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func updateFrameOfHorizontalAxis() {
        guard let axis = self.horizontalAxis else { return }
        
        // Calculate y (depend only of himself)
        
        var y: CGFloat = 0
        switch axis.axisPosition {
        case .bottom, .bottomOutside:
            y = self.layer.frame.height - axis.height
        case .top, .topOutside:
            y = 0
        }
        
        // Calculate x & width (depend of vertical axis)
        
        var x: CGFloat = 0
        var width: CGFloat = self.layer.frame.width
        
        if let verticalAxis = self.verticalAxis {
            switch verticalAxis.axisPosition {
            case .left, .right:
                x = 0
                width = self.layer.frame.width
            case .rightOutside:
                x = 0
                width = self.layer.frame.width - verticalAxis.width
            case .leftOutside:
                x = verticalAxis.frame.width
                width = self.layer.frame.width - verticalAxis.width
            }
        }
        
        axis.frame = CGRect(x: x, y: y, width: width, height: axis.height)
    }
    
    private func updateFrameOfVerticalAxis() {
        guard let axis = self.verticalAxis else { return }
        
        // Calculate x (depend only of himself)
        
        var x: CGFloat = 0
        switch axis.axisPosition {
        
        case .left, .leftOutside:
            x = 0
        case .right, .rightOutside:
            x = self.layer.frame.width - axis.width
        }
        
        // Calculate y & height (depend of horizontal axis)
        
        var y: CGFloat = 0
        var height: CGFloat = self.layer.frame.height
        
        if let horizontalAxis = self.horizontalAxis {
            switch horizontalAxis.axisPosition {
            case .top:
                y = 0
                height = self.layer.frame.height
            case .bottom:
                y = 0
                height = self.layer.frame.height
            case .topOutside:
                y = horizontalAxis.frame.height
                height = self.layer.frame.height - horizontalAxis.height
            case .bottomOutside:
                y = 0
                height = self.layer.frame.height - horizontalAxis.height
            }
        }
        
        axis.frame = CGRect(x: x, y: y, width: axis.width, height: height)
    }
}
