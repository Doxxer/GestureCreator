//: Playground - noun: a place where people can play

import UIKit

let x: [CGFloat] = [1.0, 2.0, 3.0]
let y: [CGFloat] = [12.0, 22.0, 32.0]
let t: [NSTimeInterval] = [0, 0.2, 0.32]

let d = NSNumberFormatter().numberFromString("0.2433")?.doubleValue

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}

let q = t.map { tt in
    return String(format: "%.3f", tt).toDouble() ?? 999
}

let data = ["class": "1", "x": x, "y": y, "t": t.map { q in
    return String(format: "%.3f", q).toDouble() ?? 999
} ]

if let j = NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions.allZeros, error: nil) {
    let s = NSString(data: j, encoding: NSUTF8StringEncoding)
}

