//
//  GraphView.swift
//  GraphView
//
//  Created by Charles Bessonnet on 17/08/2017.
//  Copyright © 2017 Charles Bessonnet. All rights reserved.
//

import UIKit

public protocol GraphViewDelegate: class {
    
    func tap(on graphView: GraphView, point: GraphPoint)
    func longPress(on graphView: GraphView, point: GraphPoint)
    func endLongPress(on graphView: GraphView)
}

public class GraphView: UIView {
    
    fileprivate var drawerView: DrawerView = {
        let drawerView = DrawerView()
        drawerView.translatesAutoresizingMaskIntoConstraints = false
        return drawerView
    }()
    
    private var graphs: [Graph] = []
    private var grid: Grid?
    public var verticalAxis: VerticalAxis?
    public var horizontalAxis: HorizontalAxis?
    
    public var allowsAutoresize: Bool = false {
        didSet {
            self.drawerView.autoresizeManager.allowsAutoresize = allowsAutoresize
        }
    }
    public var allowsZooming: Bool = false {
        didSet {
            self.drawerView.zoomManager.allowsZooming = allowsZooming
        }
    }
    
    public weak var delegate: GraphViewDelegate? {
        didSet {
            self.drawerView.delegate = delegate
        }
    }
    
    // MARK: - Object lifecycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.setupInterface()
        self.setupConstraints()
    }
    
    private func setupInterface() {
        self.addSubview(drawerView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.drawerView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.drawerView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.drawerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.drawerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
    
    //MARK: Components (Add & Remove)
    
    public func set(verticalAxis: VerticalAxis) {
        self.verticalAxis = verticalAxis
        self.drawerView.setVerticalAxis(axis: verticalAxis)
    }
    
    public func set(horizontalAxis: HorizontalAxis) {
        self.horizontalAxis = horizontalAxis
        self.drawerView.setHorizontalAxis(axis: horizontalAxis)
    }
    
    public func set(grid: Grid) {
        self.grid = grid
        self.drawerView.set(grid: grid)
    }
    
    public func add(graph: Graph) {
        graphs.append(graph)
        self.drawerView.add(graph: graph)
    }
    
    public func add(graphs: [Graph]) {
        for graph in graphs {
            add(graph: graph)
        }
    }
    
    public func removeAllGraphs() {
        self.graphs.removeAll()
        self.drawerView.removeAllGraphs()
    }
    
    public func remove(graph: Graph) {
        if let index = graphs.index(of: graph) {
            graphs.remove(at: index)
        }        
        self.drawerView.remove(graph: graph)
    }
    
    // MARK: - Configure
    
    public func configure(dataFrame: CGRect, dataArea: CGRect) {
        self.drawerView.configure(dataFrame: dataFrame, dataArea: dataArea)
    }
    
    public func change(dataArea: CGRect) {
        self.drawerView.change(dataArea: dataArea)
    }
    
    public func forceRedraw() {
        self.drawerView.forceToRedraw = true
    }
    
    // MARK: - Interact
    
    /// point on unit of graph
    public func selectPoint(near point: CGPoint) {
        self.drawerView.selectPoint(dataPoint: point, norm: .absisse)
        self.drawerView.forceToRedraw = true
    }
    
    /// point on unit of graph
    public func scrollTo(point: CGPoint) {
        self.drawerView.scrollTo(point: point)
    }
}

