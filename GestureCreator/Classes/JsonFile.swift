//
//  JsonFile.swift
//  GestureCreator
//
//  Created by Тимур on 13.04.15.
//  Copyright (c) 2015 Yandex LLC. All rights reserved.
//

import Foundation

class JsonFile {
    private let fileName: String
    
    var fileURL: NSURL? {
        return createFile(replace: false)
    }
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    func save(data: [Jsonable]?) {
        let stringRepresentation = data?.reduce("") { (json, x) in "\(json!)\(x.jsonRepresentation),\n" }
        
        if  let fileURL = self.fileURL,
            let fileHandler = NSFileHandle(forUpdatingURL: fileURL, error: nil),
            let dataForWriting = stringRepresentation?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        {
            fileHandler.seekToEndOfFile()
            fileHandler.writeData(dataForWriting)
            fileHandler.closeFile()
        }
    }
    
    func createFile(#replace: Bool) -> NSURL? {
        if let cacheDirectory: String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).last as? String,
            let fileURL: NSURL = NSURL(fileURLWithPath: cacheDirectory, isDirectory: true)?.URLByAppendingPathComponent(fileName)
        {
            if (replace || !NSFileManager.defaultManager().fileExistsAtPath(fileURL.path!)) {
                NSFileManager.defaultManager().createFileAtPath(fileURL.path!, contents: nil, attributes: nil)
                println("created file: \(fileURL.path!)")
            } else {
                println("file found at: \(fileURL.path!)")
            }
            return fileURL
        }
        
        return nil
    }
}