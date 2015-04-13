//
//  Stroke.swift
//  GestureCreator
//
//  Created by Тимур on 13.04.15.
//  Copyright (c) 2015 Yandex LLC. All rights reserved.
//

import Foundation
import UIKit

struct Stroke: Printable {
    private (set) var data = [CGPoint, NSTimeInterval]()
    
    mutating func appendPoint(point: CGPoint, withTimestamp t: NSTimeInterval) {
        data.append((point, t))
    }
    
    mutating func clear() {
        data.removeAll(keepCapacity: false)
    }
    
    var jsonRepresentation: String {
        let x = data.map { $0.0.x }
        let y = data.map { $0.0.y }
        let t = data.map { String(format: "%.3f", $0.1).toDouble()! }
        
        let dict = ["x": x, "y": y, "t": t]
        if let jsonData = NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.allZeros, error: nil),
            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) {
                return jsonString as String
        }
        
        return ""
    }
    
    var description: String {
        return data.description
    }
}

