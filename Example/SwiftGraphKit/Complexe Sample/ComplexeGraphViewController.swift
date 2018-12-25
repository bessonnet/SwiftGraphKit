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

    private lazy var graphView: GraphView = {
        let graphView = GraphView()
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.allowsAutoresize = true
        return graphView
    }()
    
    private lazy var graph: BezierGraph = {
        let graph = BezierGraph()
        
        graph.color         = UIColor.Graph.curve
        graph.thickness     = 3.0
        graph.gradientColors = [UIColor.Graph.Gradient.top, UIColor.Graph.Gradient.bot]
        graph.dataSource    = self
        
        return graph
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
        setupConstraints()
        
        configureGraphView()
    }
    
    // MARK: - Setup Interface
    
    private func setupInterface() {
        view.backgroundColor = .white
        view.addSubview(graphView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            graphView.leftAnchor.constraint(equalTo: view.leftAnchor),
            graphView.rightAnchor.constraint(equalTo: view.rightAnchor),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor),
            ])
    }
    
    // MARK: - Configure Graph
    
    private func configureGraphView() {
        
        let dataFrame = CGRect(x: 0, y: -2, width: 10, height: 14)
        let dataArea  = CGRect(x: -20, y: -2, width: 30, height: 14)
        
        // Add decoration
        
        let grid = Grid(stepX: 1.0, stepY: 1.0)
        grid.color = UIColor.Graph.grid
        graphView.set(grid: grid)
        
        let horizontalAxis = HorizontalAxis(step: 1.0, position: .bottomOutside)
        horizontalAxis.axisDelegate = self
        graphView.set(horizontalAxis: horizontalAxis)
        
        let verticalAxis = VerticalAxis(step: 1.0, position: .left)
        graphView.set(verticalAxis: verticalAxis)
        
        // Configure Graph View
        
        graphView.add(graph: graph)
        graphView.configure(dataFrame: dataFrame, dataArea: dataArea)
    }

}

extension ComplexeGraphViewController: GraphDataSource {
    
    func graph(graph: Graph, requestDataBetween minX: CGFloat, maxX: CGFloat, completion: @escaping (([GraphPoint]) -> (Void))) {
        
        var points = [RoundedPoint]()
        for x in Int(minX)..<Int(maxX) {
            let y = Float.random(in: -10.0..<10.0)
            
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
        
        completion(points)
    }
}

extension ComplexeGraphViewController: AxisDelegate {
    func needStringValue(for axis: Axis, at index: CGFloat) -> String {
        let i = Int(index)
        guard i >= 0, i <= 6 else { return "" }
        
        let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
        return weekdays[i]
    }
}
