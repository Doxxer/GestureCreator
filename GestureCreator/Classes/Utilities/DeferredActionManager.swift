//
//  DeferredActionManager.swift
//  GestureCreator
//
//  Created by Тимур on 08.04.15.
//  Copyright (c) 2015 Yandex LLC. All rights reserved.
//

import Foundation

//class DeferredActionManager : NSObject {
//    typealias DeferredAction = () -> ()
//    private var deferredActions = [String:DeferredAction]()
//    
//    func perform(afterDelay delay: NSTimeInterval, withKey key: String, action: DeferredAction) {
//        self.removeActionForKey(key)
//        deferredActions[key] = action
//        self perform action with delay ?????????????????
//    }
//    
//    func removeActionForKey(key: String) {
//        deferredActions.removeValueForKey(key)
//        DeferredActionManager.cancelPreviousPerformRequestsWithTarget(self, selector: Selector("runActionWithKey:"), object: key)
//    }
//    
//    func removeAllDeferredActions() {
//        deferredActions.removeAll(keepCapacity: false)
//        DeferredActionManager.cancelPreviousPerformRequestsWithTarget(self)
//    }
//    
//    private func runActionWithKey(key: String) {
//        if let action = deferredActions[key] {
//            action()
//            deferredActions.removeValueForKey(key)
//        }
//    }
//}