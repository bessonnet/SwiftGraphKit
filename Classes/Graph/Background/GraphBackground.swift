//
//  GraphBackground.swift
//  SwiftGraphKit
//
//  Created by Charles Bessonnet on 02/02/2019.
//

import UIKit

public class GraphBackground {
    public var gradientColors: [UIColor]?
    public var color: UIColor?
    public var cornerRadius: CGFloat
    
    var haveBackground: Bool {
        return color != nil  || gradientColors != nil
    }
    
    var colorRefs: [CGColor]? {
        if let color = self.color {
            return [color.cgColor, color.cgColor]
        } else if let colors = self.gradientColors {
            return colors.map({ $0.cgColor })
        }
        return nil
    }
    
    
    public init(color: UIColor, cornerRadius: CGFloat = 0) {
        self.color = color
        self.cornerRadius = cornerRadius
    }
    
    public init(gradientColors: [UIColor], cornerRadius: CGFloat = 0) {
        self.gradientColors = gradientColors
        self.cornerRadius = cornerRadius
    }
}
