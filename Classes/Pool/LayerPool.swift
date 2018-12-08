//
//  BKLayerPool.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 05/06/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

protocol OrdonableLayer: class, NSCopying {
    var index: CGFloat { get set }
}

class LayerPool {
    var element: OrdonableLayer
    var layers = [OrdonableLayer]()
    var step: CGFloat {
        didSet {
            self.layers.removeAll()
        }
    }
    
    init(element: OrdonableLayer, step: CGFloat) {
        self.element = element
        self.step = step
    }
    
    func elementsBetween(min: CGFloat, max: CGFloat) -> [OrdonableLayer] {
        let values = CGFloat.valueBetween(min: min, max: max, step: self.step)
    
        // Extract existing elements
        let minValue = values.first ?? 0
        let maxValue = values.last ?? 0
        let existingElements = self.existingElementsBetween(min: minValue, max: maxValue)
        
        // Generate missing elements if need
        
        let existingValues  = existingElements.map({ $0.index })
        let missingValues   = values.filter({ !existingValues.contains($0) })
    
        let missingElements = self.generateMissingElement(missingValues: missingValues)
    
        let elements = missingElements + existingElements
        
        return elements.sorted(by: { $0.index < $1.index })
    }
    
    private func generateMissingElement(missingValues: [CGFloat]) -> [OrdonableLayer] {
        guard !missingValues.isEmpty else { return [OrdonableLayer]() }
        
        var missingElements = [OrdonableLayer]()
        
        for value in missingValues {
            if let newElement = element.copy() as? OrdonableLayer {
                newElement.index = value
                missingElements.append(newElement)
            }
        }
        
        self.add(elements: missingElements)
        
        return missingElements
    }
    
    private func existingElementsBetween(min: CGFloat, max: CGFloat) -> [OrdonableLayer] {
        guard let minX = self.layers.first?.index else { return [OrdonableLayer]() }
        guard let maxX = self.layers.last?.index else { return [OrdonableLayer]() }
        
        // Find First index
        
        var firstIndex: Int = 0
        
        if minX < min {
            firstIndex = Int((min - minX) / self.step)
        } else {
            firstIndex = 0
        }
        
        // Find max index
        
        var lastIndex: Int = 0
        if max >= maxX {
            lastIndex = self.layers.count - 1
        } else {
            lastIndex = firstIndex + Int((max - min) / self.step)
        }
        
        let existingElements = Array(self.layers[firstIndex...lastIndex])
        
        return existingElements
    }
    
    private func add(elements: [OrdonableLayer]) {
        elements.forEach { (element) in
            self.add(element: element)
        }
        self.layers.sort(by: { $0.index < $1.index })
    }
    
    private func add(element: OrdonableLayer) {
        guard !self.layers.contains(where: { $0.index == element.index }) else { return }
        self.layers.append(element)
    }

    func removeAllData() {
        self.layers.removeAll()
    }
}
