//
//  String.swift
//  GestureCreator
//
//  Created by Тимур on 12.04.15.
//  Copyright (c) 2015 Yandex LLC. All rights reserved.
//

import Foundation

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
}
