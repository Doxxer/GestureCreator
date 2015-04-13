//
//  GestureRecorderViewController.swift
//  GestureCreator
//
//  Created by Тимур on 07.04.15.
//  Copyright (c) 2015 Yandex LLC. All rights reserved.
//

import UIKit

class GestureRecorderViewController: UIViewController {
    let deferredActionManager = DeferredActionManager()
    var gestureRecorder:GestureRecorder?
    private let kStopRecordingGestureAction = "kStopRecordingGestureAction"
    @IBOutlet weak var currentGesture: UIBarButtonItem!
    @IBOutlet weak var gestureRecorderView: GestureRecorderView!
    private var activeTouches = Set<UITouch>()
    
    @IBAction func startNewGesture(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Gesture name", message: "input the name", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler(nil)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { [weak self] (action) -> Void in
            if let gestureName = alert.textFields![0] as? UITextField {
                self?.gestureRecorder?.save()
                self?.gestureRecorder = GestureRecorder(name: gestureName.text)
                self?.updateUI()
            }
            }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func undoLastGesture(sender: UIBarButtonItem) {
        self.gestureRecorder?.undoLastGesture()
        self.updateUI()
    }
    
    @IBAction func clearAllGestures(sender: UIBarButtonItem) {
        self.gestureRecorder = nil
        GestureRecorder.clear()
        self.updateUI()
    }
    
    @IBAction func share(sender: UIBarButtonItem) {
        if let file = GestureRecorder.dataFileURL {
            let activityViewController = UIActivityViewController(activityItems: [file], applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.activeTouches.unionInPlace(touches as! Set<UITouch>)
        deferredActionManager.removeActionForKey(kStopRecordingGestureAction)
        
        for touch in filter(self.activeTouches, { $0.phase == UITouchPhase.Began }) {
            gestureRecorder?.beginStrokeWithTouch(touch)
            gestureRecorderView.beginTouch(touch)
            
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        deferredActionManager.removeActionForKey(kStopRecordingGestureAction)
        
        for touch in filter(self.activeTouches, { $0.phase == UITouchPhase.Moved }) {
            gestureRecorder?.continueStrokeWithTouch(touch)
            gestureRecorderView.moveTouch(touch)
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in filter(self.activeTouches, { $0.phase == UITouchPhase.Ended }) {
            self.gestureRecorder?.completeStrokeWithTouch(touch)
        }
        self.activeTouches.subtractInPlace(touches as! Set<UITouch>)
        
        deferredActionManager.performActionAfterDelay(1.0, withKey: kStopRecordingGestureAction) { [weak self] in
            if self?.activeTouches.isEmpty ?? false {
                self?.gestureRecorder?.complete()
                self?.gestureRecorderView?.clear()
                self?.updateUI()
            }
        }
    }
    
    private func updateUI() {
        var infoString = ""
        if let name = gestureRecorder?.gestureName, let count = gestureRecorder?.gestureData.count {
            infoString = "\(name): \(count)"
        }
        self.currentGesture.title = infoString
    }
}
