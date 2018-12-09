//
//  GraphWithDataSourceViewController.swift
//  SwiftGraphKit_Example
//
//  Created by Charles Bessonnet on 08/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import SwiftGraphKit

class GraphWithDataSourceViewController: UIViewController {

    private lazy var graphView: GraphView = {
        let graphView = GraphView()
        graphView.translatesAutoresizingMaskIntoConstraints = false
        return graphView
    }()
    
    private lazy var graph: BezierGraph = {
        let graph = BezierGraph()
        graph.color     = .darkGray
        graph.thickness = 3.0
        graph.dataSource = self
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
        
        // Add decoration
        
        let grid = Grid(stepX: 1.0, stepY: 1.0)
        grid.color = .lightGray
        graphView.set(grid: grid)
        
        // Configure Graph View
        
        graphView.add(graph: graph)
        graphView.configure(dataFrame: dataFrame, dataArea: dataArea)
    }
}

extension GraphWithDataSourceViewController: GraphDataSource {
    
    func graph(graph: Graph, requestDataBetween minX: CGFloat, maxX: CGFloat, completion: @escaping (([GraphPoint]) -> (Void))) {
        
        var points = [RoundedPoint]()
        for x in Int(minX)..<Int(maxX) {
            let y = Float.random(in: -10.0..<10.0)
            let roundedPoint = RoundedPoint(x: CGFloat(x), y: CGFloat(y))
            points.append(roundedPoint)
        }
        
        completion(points)
    }
}
