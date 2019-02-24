//
//  ReportDetail.swift
//  SwiftGraphKit_Example
//
//  Created by Charles Bessonnet on 24/02/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class ReportDetail: UIView {

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Interface
    
    private func setupInterface() {
        addSubview(amountLabel)
        addSubview(dateLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor),
            dateLabel.leftAnchor.constraint(equalTo: leftAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 60),
            
            amountLabel.topAnchor.constraint(equalTo: topAnchor),
            amountLabel.rightAnchor.constraint(equalTo: rightAnchor),
            amountLabel.heightAnchor.constraint(equalToConstant: 60),
            
            dateLabel.widthAnchor.constraint(equalTo: amountLabel.widthAnchor)
            ])
    }
    
    // MARK: - Fill Data
    
    lazy var dateFormater: DateFormatter = {
        let formater = DateFormatter()
        formater.dateFormat = "MMM dd,yyyy"
        return formater
    }()
    
    func fill(report: DailyReport) {
        amountLabel.text = "\(report.amount) $"
        dateLabel.text = "\(dateFormater.string(from: report.date))"
    }

}
