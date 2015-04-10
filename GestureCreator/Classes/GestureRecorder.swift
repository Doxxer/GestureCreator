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
    private static let dataFileName = "data.txt"
    
    static var dataFileURL: NSURL? = GestureRecorder.createDataFile(replace: false)
    
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
            let fileURL: NSURL = NSURL(fileURLWithPath: cacheDirectory, isDirectory: true)?.URLByAppendingPathComponent(dataFileName)
        {
            if (replace || !NSFileManager.defaultManager().fileExistsAtPath(fileURL.path!)) {
                NSFileManager.defaultManager().createFileAtPath(fileURL.path!, contents: nil, attributes: nil)
            }
            
            println("created file: \(fileURL.path!)")
            return fileURL
        }
        
        return nil
    }
    
    func save() {
        if let fileURL = GestureRecorder.dataFileURL {
            let gestureDataInString = gestureData.reduce("") { (stringRepresentation, gestureSample) in
                return "\(stringRepresentation){\(gestureName)} : \(gestureSample.description)\n"
            }            
            gestureDataInString.writeToURL(fileURL, atomically: false, encoding: NSUTF8StringEncoding, error: nil)
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
    }
    
    func continueStrokeWithPoint(point: CGPoint, timestamp: NSTimeInterval) {
        let timeDifference = timestamp - gestureBeginTime!
        gestureSample.append((point, timeDifference))
    }
    
    func completeGesture() {
        gestureData.append(gestureSample)
        gestureSample.removeAll(keepCapacity: false)
        gestureBeginTime = nil
    }
}