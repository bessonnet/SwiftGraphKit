//
//  DrawerView.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 04/06/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

public class DrawerView: UIView {

    weak var delegate: GraphViewDelegate?
    
    let scrollView: UIScrollView =  {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private var displayLink: CADisplayLink?
    
    fileprivate var beginTimestamp: TimeInterval = 0.0
    var time: TimeInterval = 0.0
    
    override public var bounds: CGRect {
        didSet {
            self.updateScrollViewContentSize()
            self.updateLayerFrame()
            self.forceToRedraw = true
        }
    }
    public var graphAreaCornerRadius: CGFloat = 0.0 {
        didSet {
            self.mainLayer.cornerRadius = graphAreaCornerRadius
        }
    }
    
    fileprivate var previousDataFrame = CGRect.zero
    var dataFrame: CGRect = CGRect(x: 0, y: 0, width: 10, height: 10)
    var dataArea: CGRect = CGRect(x: 0, y: 0, width: 10, height: 10)
    
    var autoresizeManager   = BKAutoresizeManager(dataFrame: CGRect(x: 0, y: 0, width: 10, height: 10))
    var zoomManager         = BKZoomManager()
    
    var graphs: [Graph] = []
    private var grid: Grid?
    var forceToRedraw: Bool = true
    public var verticalAxis: VerticalAxis?
    public var horizontalAxis: HorizontalAxis?
    private var userOutsideOfArea: Bool = false
    
    var mainLayer = CALayer()
    
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
        layer.masksToBounds             = true
        self.mainLayer.masksToBounds    = true
        self.backgroundColor = UIColor.clear
        self.scrollView.delegate = self
        
        displayLink = CADisplayLink(target: self, selector: #selector(DrawerView.runLoop))
        displayLink?.add(to: .main, forMode: RunLoop.Mode.common)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        self.scrollView.addGestureRecognizer(tapGestureRecognizer)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        self.scrollView.addGestureRecognizer(longPressGestureRecognizer)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(drawerViewDidZoom(_:)))
        scrollView.addGestureRecognizer(pinchGesture)
        
        self.setupInterface()
        self.setupConstraints()
        
        contentMode = .redraw
    }
    
    private func setupInterface() {
        self.layer.addSublayer(self.mainLayer)
        self.addSubview(scrollView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            self.scrollView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
    
    private func updateScrollViewContentSize() {
        guard frame.size != .zero else { return }
        guard dataFrame.width != 0 else { return }
        
        let width   = dataArea.width / dataFrame.width
        let offset  = (dataFrame.minX - dataArea.minX) / dataFrame.width
        
        scrollView.contentSize = CGSize(width: bounds.width * width, height: 0)
        scrollView.setContentOffset(CGPoint(x: bounds.width * offset, y: 0), animated: false)
    }
    
    //MARK: Drawing methods
    
    @objc
    func runLoop() {
        guard frame.size != .zero else { return }
        guard dataFrame.width != 0 else { return }
        guard let timestamp = displayLink?.timestamp else { return }
        self.updateDataFrameForAutoresize(timestamp: timestamp)
        guard previousDataFrame != dataFrame || previousDataFrame == CGRect.zero || forceToRedraw else { return }
        
        // Update param of draw
        
        if beginTimestamp == 0 {
            beginTimestamp = timestamp
        }
        self.time               = timestamp - beginTimestamp
        self.previousDataFrame  = dataFrame
        self.forceToRedraw      = false
        
        // Call all specific method of draw
        
        self.grid?.drawGraph(in: self)
        
        for graph in graphs {
            graph.drawGraph(in: self)
        }
        
        self.verticalAxis?.drawAxis(graphView: self)
        self.horizontalAxis?.drawAxis(graphView: self)
    }
    
    
    //MARK: Graph management
    
    public func setVerticalAxis(axis: VerticalAxis) {
        self.verticalAxis?.removeFromSuperlayer()
        self.verticalAxis = axis
        self.verticalAxis?.zPosition = LayerZPosition.axis.rawValue
        self.layer.addSublayer(axis)
        
        self.updateLayerFrame()
        self.forceToRedraw = true
    }
    
    public func setHorizontalAxis(axis: HorizontalAxis) {
        self.horizontalAxis?.removeFromSuperlayer()
        self.horizontalAxis = axis
        self.horizontalAxis?.zPosition = LayerZPosition.axis.rawValue
        self.layer.addSublayer(axis)
        
        self.updateLayerFrame()
        self.forceToRedraw = true
    }
    
    public func set(grid: Grid) {
        self.grid?.removeFromSuperlayer()
        self.grid = grid
        grid.zPosition = LayerZPosition.grid.rawValue
        self.mainLayer.addSublayer(grid)
        self.forceToRedraw = true
    }
    
    public func add(graph: Graph) {
        graphs.append(graph)
        graph.zPosition = LayerZPosition.graph.rawValue
        self.mainLayer.addSublayer(graph)
        self.forceToRedraw = true
    }
    
    public func removeAllGraphs() {
        self.graphs.forEach { (graph) in
            graph.removeFromSuperlayer()
        }
        self.graphs.removeAll()
        self.forceToRedraw = true
    }
    
    public func remove(graph: Graph) {
        if let index = graphs.firstIndex(of: graph) {
            graphs.remove(at: index)
        }
        graph.removeFromSuperlayer()
        self.forceToRedraw = true
    }
    
    // MARK: - Configuration
    
    public func configure(dataFrame: CGRect, dataArea: CGRect) {
        self.dataFrame = dataFrame
        self.dataArea = dataArea
        
        self.updateScrollViewContentSize()
        self.forceToRedraw = true
    }
    
    func change(dataArea: CGRect) {
        self.dataArea = dataArea
        self.forceDataFrameToBeValid()
        
        self.updateScrollViewContentSize()
        self.forceToRedraw = true
    }
    
    private func forceDataFrameToBeValid() {
        if self.dataFrame.minX < self.dataArea.minX {
            
            let x = self.dataArea.minX
            self.dataFrame = CGRect(x: x, y: self.dataFrame.minY, width: self.dataFrame.width, height: self.dataFrame.height)
            
        } else if self.dataArea.maxX < self.dataFrame.maxX {
            
            let x = self.dataArea.maxX - self.dataFrame.width
            self.dataFrame = CGRect(x: x, y: self.dataFrame.minY, width: self.dataFrame.width, height: self.dataFrame.height)
        }
        
        if self.dataFrame.width > self.dataArea.width {
            self.dataFrame = self.dataArea
        }
    }
    
    // MARK: - Interaction
    
    @objc
    func tap(_ gesture: UITapGestureRecognizer) {
        let touchPoint = gesture.location(in: self)
        
        // convert position on usable position on graph
        let dataPoint = self.convertDataPoint(from: touchPoint)
        self.selectPoint(dataPoint: dataPoint, norm: .quadratic)
    }
    
    func selectPoint(dataPoint: CGPoint, norm: BKNorm) {
        if let point = self.changeOfSelectedPoint(dataPoint: dataPoint, norm: norm) {
            guard let graphView = self.superview as? GraphView else { return }
            self.delegate?.tap(on: graphView, point: point)
            self.launchFeedback()
            self.forceToRedraw = true
        }
    }
    
    @objc
    func longPress(_ gesture: UILongPressGestureRecognizer) {
        let touchPoint = gesture.location(in: self)
        
        // convert position on usable position on graph
        let dataPoint = self.convertDataPoint(from: touchPoint)
        
        let changeCompletion = {
            if let point = self.changeOfSelectedPoint(dataPoint: dataPoint, norm: .quadratic) {
                guard let graphView = self.superview as? GraphView else { return }
                self.delegate?.longPress(on: graphView, point: point)
                self.forceToRedraw = true
            }
        }
        
        switch gesture.state {
        case .began:
            self.launchFeedback()
            changeCompletion()
        case .changed:
            changeCompletion()
        case .cancelled, .ended:
            guard let graphView = self.superview as? GraphView else { return }
            self.delegate?.endLongPress(on: graphView)
            self.forceToRedraw = true
        default:
            ()
        }
    }
    
    private func changeOfSelectedPoint(dataPoint: CGPoint, norm: BKNorm) -> GraphPoint? {
        var point: GraphPoint?
        for graph in self.graphs {
            point = graph.changeOfSelectedPoint(dataPoint: dataPoint, in: self, norm: norm)
        }
        return point
    }
    
    func scrollTo(point: CGPoint) {
        guard !self.dataFrame.contains(point) else { return }
        
        let scroolOnLeft = point.x < self.dataFrame.minX
        var targetDataFrame = self.dataFrame
        
        let margin = 0.2 * self.dataFrame.width
        
        if scroolOnLeft {
            let maxX = point.x + margin
            let minX = max(maxX - self.dataFrame.width, self.dataArea.minX)
            targetDataFrame = CGRect(x: minX, y: self.dataFrame.minY, width: self.dataFrame.width, height: self.dataFrame.height)
        } else {
            let minX = min(point.x - margin, self.dataArea.maxX - self.dataFrame.width)
            targetDataFrame = CGRect(x: minX, y: self.dataFrame.minY, width: self.dataFrame.width, height: self.dataFrame.height)
        }
        
        
        let offset = self.convertToContenOffset(dataPoint: targetDataFrame.origin)
        self.scrollView.setContentOffset(offset, animated: true)
    }
}

extension DrawerView: UIScrollViewDelegate {
    
    // MARK: - Scroll
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.frame != .zero else { return }
        
        let offsetX = scrollView.contentOffset.x
        let ratioX  = offsetX / self.frame.width
        let x = self.dataArea.minX + ratioX * self.dataFrame.width
        
        self.dataFrame = CGRect(x: x, y: self.dataFrame.minY, width: self.dataFrame.width, height: self.dataFrame.height)
        self.checkIfUserGoOutOfArea()
    }
    
    private func checkIfUserGoOutOfArea() {
        let validDataFrame = self.dataArea.minX <= self.dataFrame.minX && self.dataFrame.maxX <= self.dataArea.maxX
        
        if !validDataFrame && !self.userOutsideOfArea {
            self.launchFeedback()
        }
        
        self.userOutsideOfArea = !validDataFrame
    }
}

extension DrawerView {
    
    // MARK: - Zoom
    
    @objc
    func drawerViewDidZoom(_ gesture: UIPinchGestureRecognizer) {
        guard self.zoomManager.allowsZooming else { return }
        
        switch gesture.state {
        case .began:
            let touchPoint = gesture.location(in: self)
            let dataPoint = self.convertDataPoint(from: touchPoint)
            self.zoomManager.beginZoom(point: dataPoint, dataFrame: self.dataFrame)
        case .changed:
            let targetFrame = self.zoomManager.targetFrame(scaleFactor: gesture.scale)
            let x = targetFrame.minX
            let width = targetFrame.width
            self.dataFrame = CGRect(x: x, y: self.dataFrame.minY, width: width, height: self.dataFrame.height)
        default:
            self.updateScrollViewContentSize()
        }
    }
}


