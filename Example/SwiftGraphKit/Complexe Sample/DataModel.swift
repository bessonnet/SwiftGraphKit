//
//  DataModel.swift
//  SwiftGraphKit_Example
//
//  Created by Charles Bessonnet on 25/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

struct DailyReport {
    var index: Int
    var date: Date
    var amount: CGFloat
}

class DataModel {

    var reports = [DailyReport]()
    
    init() {
        
        let date = Date()
        let max  = 20
        
        for i in 0..<max {
            let amount = CGFloat(Float.random(in: 0.0..<7000.0))
            let day: TimeInterval = 24 * 60 * 60
            let currentDate = date.addingTimeInterval(TimeInterval(i - max) * day)
            let report = DailyReport(index: i, date: currentDate, amount: amount)
            
            reports.append(report)
        }
    }
    
    public func report(for index: Int) -> DailyReport? {
        return reports.first(where: { $0.index == index })
    }
    
}
