//
//  FunctionGraphViewController.swift
//  SwiftGraphKit_Example
//
//  Created by Charles Bessonnet on 08/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import SwiftGraphKit

class FunctionGraphViewController: UIViewController {

    private lazy var graphView: GraphView = {
        let graphView = GraphView()
        graphView.translatesAutoresizingMaskIntoConstraints = false
        return graphView
    }()
    
    private lazy var graph: BezierGraph = {
        let function: Function = { x in
            return pow(x, 3) - 2 * pow(x, 2)
        }
        
        let defaultPoint = GraphPoint(x: 0, y: 0)
        defaultPoint.color = .clear
        
        let graph = BezierGraph(function: function, step: 0.1, defaultPoint: defaultPoint)
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
        let dataFrame = CGRect(x: -4, y: -4, width: 8, height: 8)
        
        // Add decoration
        
        let grid = Grid(stepX: 1.0, stepY: 1.0)
        grid.color = .lightGray
        graphView.set(grid: grid)
        
        // Configure Graph View
        
        graphView.add(graph: graph)
        graphView.configure(dataFrame: dataFrame, dataArea: dataFrame)
    }
}
