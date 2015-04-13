//
//  Jsonable.swift
//  GestureCreator
//
//  Created by Тимур on 13.04.15.
//  Copyright (c) 2015 Yandex LLC. All rights reserved.
//

import Foundation

@objc protocol Jsonable {
    var jsonRepresentation: String { get }
}