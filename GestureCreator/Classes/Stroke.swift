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
    private (set) var data: [(CGPoint, NSTimeInterval)]
    private (set) var id: Int
    
    init(ID: Int) {
        self.data = []
        self.id = ID
    }
    
    mutating func appendPoint(point: CGPoint, withTimestamp t: NSTimeInterval) {
        data.append((point, t))
    }
    
    mutating func clear() {
        data.removeAll(keepCapacity: false)
    }
    
    var description: String {
        return data.description
    }
}

