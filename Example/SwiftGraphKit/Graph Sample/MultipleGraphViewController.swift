//
//  MultipleGraphViewController.swift
//  SwiftGraphKit_Example
//
//  Created by Charles Bessonnet on 30/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SwiftGraphKit

class MultipleGraphViewController: UIViewController {

    private lazy var graphView: GraphView = {
        let graphView = GraphView()
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.graphAreaCornerRadius = 10
        return graphView
    }()
    
    private lazy var firstGraph: BreakLineGraph = {
        let graph = BreakLineGraph()
        graph.color     = .darkGray
        graph.graphBackground = GraphBackground(color: UIColor.Graph.Multi.green, cornerRadius: 10)
        graph.thickness = 3.0
        return graph
    }()
    
    private lazy var secondGraph: BreakLineGraph = {
        let graph = BreakLineGraph()
        graph.color     = .darkGray
        graph.graphBackground = GraphBackground(color: UIColor.Graph.Multi.blue, cornerRadius: 10)
        graph.thickness = 3.0
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
        
        let dataFrame = CGRect(x: 0, y: -2, width: 10, height: 14)
        let dataArea  = CGRect(x: -20, y: -2, width: 30, height: 14)
        
        // configure first graph
        
        var points = [GraphPoint]()
        
        for x in Int(dataArea.minX)..<Int(dataArea.maxX) {
            let y = Float.random(in: 0..<10.0)
            let roundedPoint = RoundedPoint(x: CGFloat(x), y: CGFloat(y))
            points.append(roundedPoint)
        }
        
        firstGraph.addData(data: points)
        
        // configure second graph
        
        var points2 = [GraphPoint]()
        
        for x in Int(dataArea.minX)..<Int(dataArea.maxX) {
            let y = Float.random(in: 0..<10.0)
            let roundedPoint = RoundedPoint(x: CGFloat(x), y: CGFloat(y))
            points2.append(roundedPoint)
        }
        
        secondGraph.addData(data: points2)
        
        // Add decoration
        
        let grid = Grid(stepX: 1.0, stepY: 1.0)
        grid.color = .lightGray
        graphView.set(grid: grid)
        
        // Configure Graph View
        
        graphView.add(graphs: [firstGraph, secondGraph])
        graphView.configure(dataFrame: dataFrame, dataArea: dataArea)
    }
}
