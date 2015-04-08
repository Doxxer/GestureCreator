//
//  GestureRecorderViewController.swift
//  GestureCreator
//
//  Created by Тимур on 07.04.15.
//  Copyright (c) 2015 Yandex LLC. All rights reserved.
//

import UIKit

class GestureRecorderViewController: UIViewController {
    @IBOutlet weak var gestureRecorderView: GestureRecorderView!
    let deferredActionManager = DeferredActionManager()
    let gestureRecorder = GestureRecorder()
    private let kStopRecordingGestureAction = "kStopRecordingGestureAction"
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            deferredActionManager.removeActionForKey(kStopRecordingGestureAction)
            gestureRecorderView.moveToPoint(touch.locationInView(gestureRecorderView))
            gestureRecorder.beginStrokeAtPoint(touch.locationInView(gestureRecorderView?.window), timestamp: touch.timestamp)
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            deferredActionManager.removeActionForKey(kStopRecordingGestureAction)
            gestureRecorder.continueStrokeWithPoint(touch.locationInView(gestureRecorderView?.window), timestamp: touch.timestamp)
            gestureRecorderView.addLineToPoint(touch.locationInView(gestureRecorderView))
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        deferredActionManager.performActionAfterDelay(1.0, withKey: kStopRecordingGestureAction) { [weak self] in
            self?.gestureRecorderView?.clear()
            self?.gestureRecorder.completeGesture()
        }
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        self.gestureRecorderView?.clear()
        gestureRecorder.completeGesture()
    }
}
