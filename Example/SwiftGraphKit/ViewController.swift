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
    
    enum GraphSample: String, CaseIterable {
        case complexeGraph      = "Sample Demo"
        
        case simpleGraph        = "Simple Graph"
        case scrollableGraph    = "Scrollable Graph"
        case dataSourceGraph    = "Graph with dataSource"
        case functionGraph      = "Graph with function"
        case simpleBarGraph     = "Simple bar graph"
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.dataSource = self
        tableView.delegate   = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        
        return tableView
    }()
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
        setupConstraints()
    }
    
    // MARK: - Setup Interface
    
    private func setupInterface() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GraphSample.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        
        let typeGraph = GraphSample.allCases[indexPath.row]
        cell.textLabel?.text = typeGraph.rawValue
        
        return cell
    }
    
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let typeGraph = GraphSample.allCases[indexPath.row]
        
        let viewController: UIViewController
        switch typeGraph {
        case .simpleGraph:
            viewController = SimpleGraphViewController()
        case .scrollableGraph:
            viewController = ScrollableGraphViewController()
        case .dataSourceGraph:
            viewController = GraphWithDataSourceViewController()
        case .functionGraph:
            viewController = FunctionGraphViewController()
        case .simpleBarGraph:
            viewController = SimpleBarGraphViewController()
        case .complexeGraph:
            viewController = ComplexeGraphViewController()
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}
