//
//  Date+Formater.swift
//  SwiftGraphKit_Example
//
//  Created by Charles Bessonnet on 24/02/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

extension Date {
    static let dayFormatter = DateFormatter()
    static let calendar = Calendar.current
    
    func weekSymbol() -> String {
        let index = Date.calendar.component(.weekday, from: self)
        let dayString = Date.dayFormatter.weekdaySymbols[index - 1]
        return String(dayString.prefix(1))
    }
}
