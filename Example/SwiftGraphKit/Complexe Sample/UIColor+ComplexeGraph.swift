//
//  UIColor+ComplexeGraph.swift
//  SwiftGraphKit_Example
//
//  Created by Charles Bessonnet on 25/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int, alpha: Int = 255) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
    }
    
    
    struct Graph {
        static let curve = UIColor(red: 60, green: 141, blue: 249)
        static let point = UIColor(red: 60, green: 141, blue: 249)
        static let grid  = UIColor(red: 240, green: 239, blue: 242)
        
        struct Gradient {
            static let top = UIColor(red: 60, green: 141, blue: 249)
            static let bot = UIColor(red: 255, green: 255, blue: 255, alpha: 0)
        }
        
        struct Multi {
            static let green = UIColor(red: 0, green: 250, blue: 100, alpha: 100)
            static let blue  = UIColor(red: 63, green: 163, blue: 251, alpha: 100)
        }
    }
}
