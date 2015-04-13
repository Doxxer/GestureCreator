//
//  GestureRecorder.swift
//  GestureCreator
//
//  Created by Тимур on 08.04.15.
//  Copyright (c) 2015 Yandex LLC. All rights reserved.
//

import Foundation
import UIKit

class GestureRecorder {
    typealias GestureCollection = [Gesture]
    
    let gestureName: String
    private var currentGesture: Gesture
    private(set) var gestureData = GestureCollection()
    private static let dataFileName = "data.json"
    
    static var dataFileURL: NSURL? {
        return GestureRecorder.createDataFile(replace: false)
    }
    
    init(name: String) {
        self.gestureName = name
        self.currentGesture = Gesture(name: name)
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
        let gestureDataInString = gestureData.reduce("") { (json, gestureSample) in
            return "\(json)\(gestureSample.jsonRepresentation),\n"
        }
        
        if let fileURL = GestureRecorder.dataFileURL, let fileHandler = NSFileHandle(forUpdatingURL: fileURL, error: nil), let data = gestureDataInString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            fileHandler.seekToEndOfFile()
            fileHandler.writeData(gestureDataInString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
            fileHandler.closeFile()
        }
    }
    
    func beginStrokeWithTouch(touch: UITouch) {
        currentGesture.beginStrokeWithTouch(touch)
    }
    
    func continueStrokeWithTouch(touch: UITouch) {
        currentGesture.continueStrokeWithTouch(touch)
    }
    
    func completeStrokeWithTouch(touch: UITouch) {
        currentGesture.completeStrokeWithTouch(touch)
    }
    
    func complete() {
        gestureData.append(currentGesture)
        currentGesture = Gesture(name: self.gestureName)
        
        println(gestureData.map { $0.jsonRepresentation })
    }
    
    func undoLastGesture() {
        if (self.gestureData.count > 0) {
            self.gestureData.removeLast()
        }
    }
}