//
//  SimpleGraphViewController.swift
//  SwiftGraphKit_Example
//
//  Created by Charles Bessonnet on 12/11/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import SwiftGraphKit

class SimpleGraphViewController: UIViewController {

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
        let minX = 0
        let maxX = 10
        let dataFrame = CGRect(x: minX, y: -2, width: maxX - minX, height: 14)
        
        // configure graph
        
        var points = [GraphPoint]()
        
        for x in minX..<maxX {
            let y = Float.random(in: 0.0..<10.0)
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
        graphView.configure(dataFrame: dataFrame, dataArea: dataFrame)
    }

}
