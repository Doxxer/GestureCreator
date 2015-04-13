//
//  Gesture.swift
//  GestureCreator
//
//  Created by Тимур on 13.04.15.
//  Copyright (c) 2015 Yandex LLC. All rights reserved.
//

import Foundation
import UIKit

class Gesture : Jsonable, Printable {
    private var gestureBeginTime: NSTimeInterval?
    let name: String
    var activeStrokes: [UITouch:Stroke] = [:]
    var completedStrokes: [Stroke] = []
    
    init(name: String) {
        self.name = name
    }
    
    func beginStrokeWithTouch(touch: UITouch) {
        gestureBeginTime = gestureBeginTime ?? touch.timestamp // set begin time if it was unsetted
        
        activeStrokes.updateValue(Stroke(), forKey: touch)
        activeStrokes[touch]!.appendPoint(touch.locationInView(touch.window), withTimestamp: touch.timestamp - gestureBeginTime!)
    }
    
    func continueStrokeWithTouch(touch: UITouch) {
        let timeDifference = touch.timestamp - gestureBeginTime!
        activeStrokes[touch]!.appendPoint(touch.locationInView(touch.window), withTimestamp: touch.timestamp - gestureBeginTime!)
    }
    
    func completeStrokeWithTouch(touch: UITouch) {
        completedStrokes.append(activeStrokes.removeValueForKey(touch)!)
    }
    
    @objc var jsonRepresentation: String {
        let data = completedStrokes.map { $0.data }
        let x = data.flatMap { stroke in stroke.map { $0.0.x } }
        let y = data.flatMap { stroke in stroke.map { $0.0.y } }
        let t = data.flatMap { stroke in stroke.map { String(format: "%.3f", $0.1).toDouble()! } }
        
        let dict = ["x": x, "y": y, "t": t]
        if let jsonData = NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.allZeros, error: nil),
            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) {
                return jsonString as String
        }
        
        return ""
    }
    
    var description: String {
        return "active: [\(activeStrokes)] \(self.completedStrokes)\n"
    }
}
