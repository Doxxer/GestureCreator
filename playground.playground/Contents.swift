//: Playground - noun: a place where people can play

import UIKit

let x: [CGFloat] = [1.0, 2.0, 3.0]
let y: [CGFloat] = [12.0, 22.0, 32.0]
let t: [NSTimeInterval] = [0, 0.2, 0.32]

let d = 0.427149238

let data = ["class": "1", "x": x, "y": y, "t": t.map {String(format: "%.2f", $0)} ]

if let j = NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions.allZeros, error: nil) {
    let s = NSString(data: j, encoding: NSUTF8StringEncoding)
}

