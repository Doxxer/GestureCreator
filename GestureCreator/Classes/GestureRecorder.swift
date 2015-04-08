//
//  GestureRecorder.swift
//  GestureCreator
//
//  Created by Тимур on 08.04.15.
//  Copyright (c) 2015 Yandex LLC. All rights reserved.
//

import Foundation
import CoreGraphics

class GestureRecorder {
    var gesture = [(CGPoint, Double)]()
    var gestureBeginTime: NSTimeInterval?
    
    func beginStrokeAtPoint(point: CGPoint, timestamp: NSTimeInterval) {
        gestureBeginTime = gestureBeginTime ?? timestamp // set begin time if it was unsetted
        
        var timeDifference = timestamp - gestureBeginTime!        
        gesture.append((point, timeDifference))
        println("Begin at point: \(point) at \(timestamp). Diff = \(timeDifference)")
    }
    
    func continueStrokeWithPoint(point: CGPoint, timestamp: NSTimeInterval) {
        let timeDifference = timestamp - gestureBeginTime!
        gesture.append((point, timeDifference))
        println("Conti at point: \(point) at \(timestamp). Diff = \(timeDifference)")
    }
    
    func completeGesture() {
        println("stop recording. Writing to file...")
        gesture.removeAll(keepCapacity: true)
        gestureBeginTime = nil
    }
}