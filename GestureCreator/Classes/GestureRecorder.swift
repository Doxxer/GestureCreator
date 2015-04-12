//
//  GestureRecorder.swift
//  GestureCreator
//
//  Created by Тимур on 08.04.15.
//  Copyright (c) 2015 Yandex LLC. All rights reserved.
//

import Foundation
import CoreGraphics

struct GestureSample: Printable {
    let name: String
    var data = [CGPoint, NSTimeInterval]()
    
    init(name: String) {
        self.name = name
    }
    
    mutating func appendPoint(point: CGPoint, withTimestamp t: NSTimeInterval) {
        data.append((point, t))
    }
    
    mutating func clear() {
        data.removeAll(keepCapacity: false)
    }
    
    var description: String {
        let x = data.map { $0.0.x }
        let y = data.map { $0.0.y }
        let t = data.map { String(format: "%.3f", $0.1).toDouble()! }
        
        let dict = ["tag": self.name, "x": x, "y": y, "t": t]
        if let jsonData = NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.allZeros, error: nil),
            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) {
                return jsonString as String
        }
        
        return ""
    }
}

class GestureRecorder {
    typealias GestureCollection = [GestureSample]
    
    let gestureName: String
    private var gestureBeginTime: NSTimeInterval?
    private var sample: GestureSample
    private(set) var gestureData = GestureCollection()
    private static let dataFileName = "data.json"
    
    static var dataFileURL: NSURL? {
        return GestureRecorder.createDataFile(replace: false)
    }
    
    init(name: String) {
        gestureName = name
        sample = GestureSample(name: name)
    }
    
    class func clear() {
        createDataFile(replace: true)
    }
    
    private class func createDataFile(replace: Bool = false) -> NSURL? {
        if let cacheDirectory: String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last as? String,
            let fileURL: NSURL = NSURL(fileURLWithPath: cacheDirectory, isDirectory: true)?.URLByAppendingPathComponent(dataFileName)
        {
            if (replace || !NSFileManager.defaultManager().fileExistsAtPath(fileURL.path!)) {
                NSFileManager.defaultManager().createFileAtPath(fileURL.path!, contents: nil, attributes: nil)
                println("created file: \(fileURL.path!)")
            } else {
                println("file found at: \(fileURL.path!)")
            }
            return fileURL
        }
        
        return nil
    }
    
    func save() {
        let gestureDataInString = gestureData.reduce("") { (stringRepresentation, gestureSample) in
            return "\(stringRepresentation)\(gestureSample.description),\n"
        }
        
        if let fileURL = GestureRecorder.dataFileURL, let fileHandler = NSFileHandle(forUpdatingURL: fileURL, error: nil), let data = gestureDataInString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            fileHandler.seekToEndOfFile()
            fileHandler.writeData(gestureDataInString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            fileHandler.closeFile()
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
        sample.appendPoint(point, withTimestamp: timeDifference)
    }
    
    func continueStrokeWithPoint(point: CGPoint, timestamp: NSTimeInterval) {
        let timeDifference = timestamp - gestureBeginTime!
        sample.appendPoint(point, withTimestamp: timeDifference)
    }
    
    func completeGesture() {
        gestureData.append(sample)
        sample.clear()
        gestureBeginTime = nil
    }
}