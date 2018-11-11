//
//  ViewController.swift
//  SwiftGraphKit
//
//  Created by charles.bessonnet91@orange.fr on 11/11/2018.
//  Copyright (c) 2018 charles.bessonnet91@orange.fr. All rights reserved.
//

import UIKit
import SwiftGraphKit


class ViewController: UIViewController {
    
    private lazy var graphView: GraphView = {
        let graphView = GraphView()
        graphView.translatesAutoresizingMaskIntoConstraints = false
        return graphView
    }()
    
    private lazy var graph: BezierGraph = {
        let graph = BezierGraph()
        graph.color     = .darkGray
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
        
        // configure graph
        
        var points = [GraphPoint]()
        
        for x in Int(dataArea.minX)..<Int(dataArea.maxX) {
            let y = Float.random(in: -10.0..<10.0)
            let roundedPoint = RoundedPoint(x: CGFloat(x), y: CGFloat(y))
            points.append(roundedPoint)
        }
        
        graph.addData(data: points)
        
        // Add decoration
        
        let grid = Grid(stepX: 1.0, stepY: 1.0)
        grid.color = .lightGray
        graphView.set(grid: grid)
        
        // Configure Graph View
        
        graphView.add(graph: graph)
        graphView.configure(dataFrame: dataFrame, dataArea: dataArea)
    }
    
}
