//
//  GestureRecorderView.swift
//  GestureCreator
//
//  Created by Тимур on 07.04.15.
//  Copyright (c) 2015 Yandex LLC. All rights reserved.
//

import UIKit

class GestureRecorderView: UIView {
    let touchPath = UIBezierPath()
    let touchStrokeColor = UIColor.blueColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        self.backgroundColor = UIColor.clearColor()
        touchPath.lineWidth = 10
        touchPath.miterLimit = 0
        touchPath.lineCapStyle = kCGLineCapRound
    }
    
    func moveToPoint(point: CGPoint) {
        touchPath.moveToPoint(point)
    }
    
    func addLineToPoint(point: CGPoint) {
        touchPath.addQuadCurveToPoint(point, controlPoint: point)
        setNeedsDisplay()
    }
    
    func clear() {
        touchPath.removeAllPoints()
        setNeedsDisplay()
    }

    override func drawRect(rect: CGRect) {
        touchStrokeColor.setStroke()
        touchPath.strokeWithBlendMode(kCGBlendModeNormal, alpha: 0.2)
    }
}
