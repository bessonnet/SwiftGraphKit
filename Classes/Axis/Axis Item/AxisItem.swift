//
//  BKAxisItem.swift
//  BKGraphKit
//
//  Created by Charles Bessonnet on 04/06/2018.
//  Copyright © 2018 Charles Bessonnet. All rights reserved.
//

import UIKit

class AxisItem: CALayer {
    
    var backgroundLayerColor: UIColor = UIColor.white.withAlphaComponent(0.5)
    var textColor: UIColor = UIColor.black {
        didSet {
            self.textLayer.foregroundColor = textColor.cgColor
            self.changeAttributeText()
        }
    }
    var font: UIFont = UIFont.systemFont(ofSize: 14.0) {
        didSet {
            self.updateSize()
            self.changeAttributeText()
        }
    }
    var text: String? {
        didSet {
            self.updateSize()
            self.changeAttributeText()
        }
    }
    
    var index: CGFloat  = 0.0
    var size: CGSize    = .zero
    var border: CGFloat = 5.0
    
    private var backgroundLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: 20, height: 20), cornerRadius: 10).cgPath
        return shapeLayer
    }()
    
    private var textLayer: CATextLayer = {
        let textLayer = CATextLayer()
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        return textLayer
    }()
    
    // MARK: - Init
    
    init(text: String?) {
        self.text = text
        super.init()
        
        self.textLayer.string = text
        
        self.addSublayer(self.backgroundLayer)
        self.addSublayer(self.textLayer)
        self.delegate = self
        self.backgroundLayer.delegate = self
        self.textLayer.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Draw
    
    private func changeAttributeText() {
        guard let string = text else { return }
        let myAttributes = [
            NSAttributedString.Key.font: self.font ,
            NSAttributedString.Key.foregroundColor: self.textColor
        ]
        let attributedString = NSAttributedString(string: string, attributes: myAttributes )
        self.textLayer.string = attributedString
    }
    
    private func updateSize() {
        guard let axisText = self.text else { return }
        let size = (axisText as NSString).size(withAttributes: [NSAttributedString.Key.font : self.font])
        self.size = CGSize(width: size.width + 2 * self.border, height: size.height)
    }
    
    func drawAxisItem(in graphView: DrawerView) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: 20)
        self.textLayer.frame = rect
        self.backgroundLayer.fillColor = self.backgroundLayerColor.cgColor
        self.backgroundLayer.path = UIBezierPath.init(roundedRect: rect, cornerRadius: 10).cgPath
    }
}

extension AxisItem: CALayerDelegate {
    
    public func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return NSNull()
    }
}

extension AxisItem: OrdonableLayer {
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = AxisItem(text: nil)
        copy.index = self.index
        return copy
    }
}

extension AxisItem {
    override var description: String {
        return "<BKAxisItem : index = \(self.index), text = \(self.text ?? "")>"
    }
}
