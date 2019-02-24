//
//  ReportDetail.swift
//  SwiftGraphKit_Example
//
//  Created by Charles Bessonnet on 24/02/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class ReportDetail: UIView {
    
    private lazy var dateTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Date:"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        return label
    }()
    
    private lazy var amountTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Amount:"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupInterface()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Interface
    
    private func setupInterface() {
        addSubview(dateTitleLabel)
        addSubview(amountTitleLabel)
        addSubview(amountLabel)
        addSubview(dateLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            dateTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            dateTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            
            amountTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            amountTitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            
            dateTitleLabel.widthAnchor.constraint(equalTo: amountTitleLabel.widthAnchor),
            dateTitleLabel.rightAnchor.constraint(equalTo: amountTitleLabel.leftAnchor, constant: 10),
            
            dateLabel.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor),
            dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            
            amountLabel.topAnchor.constraint(equalTo: amountTitleLabel.bottomAnchor),
            amountLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            
            dateLabel.widthAnchor.constraint(equalTo: amountLabel.widthAnchor),
            dateLabel.rightAnchor.constraint(equalTo: amountLabel.leftAnchor, constant: 10),
            ])
    }
    
    // MARK: - Fill Data
    
    lazy var dateFormater: DateFormatter = {
        let formater = DateFormatter()
        formater.dateFormat = "MMM dd,yyyy"
        return formater
    }()
    
    lazy var amountFormatter: NumberFormatter = {
        let formater = NumberFormatter()
        formater.numberStyle = .currency
        formater.locale = Locale.current
        return formater
    }()
    
    func fill(report: DailyReport) {
        amountLabel.text = amountFormatter.string(from: report.amount as NSNumber)
        dateLabel.text = "\(dateFormater.string(from: report.date))"
    }

}
