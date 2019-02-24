//
//  ComplexeGraphViewController.swift
//  SwiftGraphKit_Example
//
//  Created by Charles Bessonnet on 22/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import SwiftGraphKit

class ComplexeGraphViewController: UIViewController {
    
    private var model = DataModel()

    private lazy var graphView: GraphView = {
        let graphView = GraphView()
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.allowsAutoresize = true
        graphView.delegate = self
        return graphView
    }()
    
    private lazy var graph: BezierGraph = {
        let graph = BezierGraph()
        
        graph.color         = UIColor.Graph.curve
        graph.thickness     = 3.0
        graph.graphBackground = GraphBackground(gradientColors: [UIColor.Graph.Gradient.top, UIColor.Graph.Gradient.bot])
        graph.dataSource    = self
        
        return graph
    }()
    
    private lazy var reportDetail: ReportDetail = {
        let reportDetail = ReportDetail()
        reportDetail.translatesAutoresizingMaskIntoConstraints = false
        return reportDetail
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
        setupConstraints()
        
        configureGraphView()
        configureDetail()
    }
    
    // MARK: - Setup Interface
    
    private func setupInterface() {
        view.backgroundColor = .white
        view.addSubview(graphView)
        view.addSubview(reportDetail)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            graphView.leftAnchor.constraint(equalTo: view.leftAnchor),
            graphView.rightAnchor.constraint(equalTo: view.rightAnchor),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor),
            
            reportDetail.topAnchor.constraint(equalTo: graphView.bottomAnchor),
            reportDetail.leftAnchor.constraint(equalTo: view.leftAnchor),
            reportDetail.rightAnchor.constraint(equalTo: view.rightAnchor),
            reportDetail.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    // MARK: - Configure Graph
    
    private func configureGraphView() {
        let width: CGFloat = 7
        let x: CGFloat = CGFloat(model.reports.count + 1) - width
        let dataFrame = CGRect(x: x, y: 0, width: 7, height: 1000)
        let dataArea  = CGRect(x: 0, y: 0, width: model.reports.count + 1, height: 1000)
        
        // Add decoration
        
        let grid = Grid(stepX: 1.0, stepY: 1000)
        grid.color = UIColor.Graph.grid
        graphView.set(grid: grid)
        
        let horizontalAxis = HorizontalAxis(step: 1.0, position: .bottomOutside)
        horizontalAxis.axisDelegate = self
        graphView.set(horizontalAxis: horizontalAxis)
        
        let verticalAxis = VerticalAxis(step: 1000, position: .left)
        graphView.set(verticalAxis: verticalAxis)
        
        // Configure Graph View
        
        graphView.add(graph: graph)
        graphView.configure(dataFrame: dataFrame, dataArea: dataArea)
    }
    
    private func configureDetail() {
        guard let report = model.reports.last else { return }
        reportDetail.fill(report: report)
    }

}

extension ComplexeGraphViewController: GraphDataSource {
    
    func graph(graph: Graph, requestDataBetween minX: CGFloat, maxX: CGFloat, completion: @escaping (([GraphPoint]) -> (Void))) {
        
        var points = [RoundedPoint]()
        for x in Int(minX)..<Int(maxX) {
            
            if let report = model.report(for: x) {
                
                let y = report.amount
                
                let roundedPoint = RoundedPoint(x: CGFloat(x), y: CGFloat(y))
                
                roundedPoint.fillColor              = UIColor.Graph.point
                roundedPoint.strokeColor            = .white
                roundedPoint.selectedFillColor      = .white
                roundedPoint.selectedStrokeColor    = UIColor.Graph.point
                roundedPoint.radius         = 5
                roundedPoint.selectedRadius = 6
                roundedPoint.thickness      = 3
                
                points.append(roundedPoint)
            }
        }
        
        // select last point
        points.last?.selected = true
        
        completion(points)
    }
}

extension ComplexeGraphViewController: AxisDelegate {
    func needStringValue(for axis: Axis, at index: CGFloat) -> String {
        if let report = model.report(for: Int(index)) {
            let date = report.date
            return date.weekSymbol()
        }
        return ""
    }
}

extension ComplexeGraphViewController: GraphViewDelegate {
    
    func tap(on graphView: GraphView, point: GraphPoint) {
        guard let report = model.report(for: Int(point.x)) else { return }
        reportDetail.fill(report: report)
    }
    
    func longPress(on graphView: GraphView, point: GraphPoint) {}
    
    func endLongPress(on graphView: GraphView) {}
}
