//: Playground - noun: a place where people can play

import UIKit

@objc protocol j {
    var prop: String { get }
}

func foo(data: [j]?) -> [String]? {
    if let da = data {
        return da.map { $0.prop }
    }
    return nil
}

class Bar : j {
    @objc var prop: String {
        return "trololo"
    }
}

let data = [Bar(), Bar(), Bar()]

let q = foo(data)