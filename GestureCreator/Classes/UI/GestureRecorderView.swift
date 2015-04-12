//
//  GestureRecorderView.swift
//  GestureCreator
//
//  Created by Тимур on 07.04.15.
//  Copyright (c) 2015 Yandex LLC. All rights reserved.
//

import UIKit

class GestureRecorderView: UIView {
    private var touchPathes:[UITouch:UIBezierPath] = [:]
    let touchStrokeColor = UIColor.blueColor()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
    }
    
    func beginTouch(touch: UITouch) {
        let newPath: (() -> UIBezierPath) = {
            let path = UIBezierPath()
            path.lineWidth = 10
            path.miterLimit = 0
            path.lineCapStyle = kCGLineCapRound
            return path
        }
        touchPathes.updateValue(newPath(), forKey: touch)
        touchPathes[touch]!.moveToPoint(touch.locationInView(self))
    }
    
    func moveTouch(touch: UITouch) {
        if let touchPath = touchPathes[touch] {
            touchPath.addLineToPoint(touch.locationInView(self))
            setNeedsDisplay()
        }
    }
    
    func clear() {
        touchPathes.removeAll(keepCapacity: false)
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        touchStrokeColor.setStroke()
        for touchPath in self.touchPathes.values {
            touchPath.strokeWithBlendMode(kCGBlendModeNormal, alpha: 0.2)
        }
    }
}
