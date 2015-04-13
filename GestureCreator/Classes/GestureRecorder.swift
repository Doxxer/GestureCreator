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
    let gestureName: String
    private var currentGesture: Gesture
    private(set) var gestureData: [Gesture] = []
    
    init(name: String) {
        self.gestureName = name
        self.currentGesture = Gesture(name: name)
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
    }
    
    func undoLastGesture() {
        if (self.gestureData.count > 0) {
            self.gestureData.removeLast()
        }
    }
}