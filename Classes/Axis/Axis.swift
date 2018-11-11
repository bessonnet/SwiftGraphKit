//
//  Axis.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 29/06/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

public protocol AxisDelegate: class {
    func needStringValue(for axis: Axis, at index: CGFloat) -> String
}

public protocol Axis: class {
    var axisDelegate: AxisDelegate? { get set }
    func drawAxis(graphView: DrawerView)
    func removeAllData()
}
