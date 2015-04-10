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
    typealias GestureSample = [(CGPoint, NSTimeInterval)]
    typealias GestureCollection = [GestureSample]
    
    let gestureName: String?
    private var gestureBeginTime: NSTimeInterval?
    private var gestureSample = GestureSample()
    private var gestureData = GestureCollection()
    
    init(name: String) {
        gestureName = name
    }
    
    var gestureSamplesCount: Int {
        get {
            return gestureData.count
        }
    }
    
    class func clear() {
        // TODO remove file
    }
    
    func save() {
        println("saving to file")
    }
    
    func undoLastGesture() {
        if (self.gestureData.count > 0) {
            self.gestureData.removeLast()
        }
    }
    
    func beginStrokeAtPoint(point: CGPoint, timestamp: NSTimeInterval) {
        gestureBeginTime = gestureBeginTime ?? timestamp // set begin time if it was unsetted
        let timeDifference = timestamp - gestureBeginTime!
        gestureSample.append((point, timeDifference))
        println("Begin at point: \(point) at \(timestamp). Diff = \(timeDifference)")
    }
    
    func continueStrokeWithPoint(point: CGPoint, timestamp: NSTimeInterval) {
        let timeDifference = timestamp - gestureBeginTime!
        gestureSample.append((point, timeDifference))
        println("Conti at point: \(point) at \(timestamp). Diff = \(timeDifference)")
    }
    
    func completeGesture() {
        println("gesture created")
        gestureData.append(gestureSample)
        gestureSample.removeAll(keepCapacity: false)
        gestureBeginTime = nil
    }
}