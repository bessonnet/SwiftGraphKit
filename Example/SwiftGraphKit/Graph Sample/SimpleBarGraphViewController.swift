//
//  SimpleBarGraphViewController.swift
//  SwiftGraphKit_Example
//
//  Created by Charles Bessonnet on 13/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import SwiftGraphKit

class SimpleBarGraphViewController: UIViewController {

    private lazy var graphView: GraphView = {
        let graphView = GraphView()
        graphView.translatesAutoresizingMaskIntoConstraints = false
        return graphView
    }()
    
    private lazy var graph: Graph = {
        let graph = Graph()
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
            graphView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            graphView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            graphView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            graphView.heightAnchor.constraint(equalTo: graphView.widthAnchor),
            ])
    }
    
    // MARK: - Configure Graph
    
    private func configureGraphView() {
        let margin: CGFloat = 0.1
        let minX: CGFloat = 0
        let maxX: CGFloat = 6
        let dataFrame = CGRect(x: minX - margin, y: -margin, width: maxX - minX + 2 * margin, height: 10)
        
        // configure graph
        
        var points = [GraphPoint]()
        
        for x in 0..<7 {
            let y = Float.random(in: 1..<9.0)
            let bar = RoundedBar(x: CGFloat(x), minY: 0, maxY: CGFloat(y))
            bar.width   = 10
            bar.radius  = 5
            bar.color   = .darkGray
            points.append(bar)
        }
        
        graph.addData(data: points)
        
        // Add decoration
        
        let grid = Grid(stepX: 1.0, stepY: 1.0)
        grid.color = .lightGray
        graphView.set(grid: grid)
        
        let horizontalAxis = HorizontalAxis(step: 1.0, position: .bottomOutside)
        horizontalAxis.axisDelegate = self
        graphView.set(horizontalAxis: horizontalAxis)
        
        // Configure Graph View
        
        graphView.add(graph: graph)
        graphView.configure(dataFrame: dataFrame, dataArea: dataFrame)
    }
}

extension SimpleBarGraphViewController: AxisDelegate {
    func needStringValue(for axis: Axis, at index: CGFloat) -> String {
        let i = Int(index)
        guard i >= 0, i <= 6 else { return "" }
        
        let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
        return weekdays[i]
    }
}
