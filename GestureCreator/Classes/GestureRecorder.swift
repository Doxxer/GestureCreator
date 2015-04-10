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
    
    let gestureName: String
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
        createDataFile(replace: true)
    }
    
    private class func createDataFile(#replace: Bool) -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        
        if let cacheDirectory: String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last as? String,
            let fileURL: NSURL = NSURL(fileURLWithPath: cacheDirectory, isDirectory: true)?.URLByAppendingPathComponent("data.txt")
        {
            if (replace || !NSFileManager.defaultManager().fileExistsAtPath(fileURL.path!)) {
                NSFileManager.defaultManager().createFileAtPath(fileURL.path!, contents: nil, attributes: nil)
            }
            return fileURL
        }
        
        return nil
    }
    
    func save() {
        let fileManager = NSFileManager.defaultManager()
        if let fileURL = self.dynamicType.createDataFile(replace: false) {
            let s = gestureData.reduce("") { (stringRepresentation, gestureSample) in
                return "\(stringRepresentation){\(gestureName)} : \(gestureSample.description)\n"
            }            
            s.writeToURL(fileURL, atomically: false, encoding: NSUTF8StringEncoding, error: nil)
        }
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