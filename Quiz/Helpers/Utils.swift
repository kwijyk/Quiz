//
//  Utils.swift
//  LocalStorege_cw20
//
//  Created by Sergey Intern  on 12/12/17.
//  Copyright © 2017 Sergey Intern . All rights reserved.
//

import Foundation

struct Utils {
    
    static var directoryPath: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    static func pathInDocument(withComponent component: String) -> URL {
        return directoryPath.appendingPathComponent(component)
    }
    
    static func createFolder(withName name: String) -> URL {
        
        let dataPath = directoryPath.appendingPathComponent(name)
        
        do {
            try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        
        return dataPath
    }
    
    static func writeDown(text: String, toFile fileNamed: String, folder: String = "Questions") {
        let writePath = directoryPath.appendingPathComponent(folder)
        try? FileManager.default.createDirectory(atPath: writePath.path, withIntermediateDirectories: true)
        let file = writePath.appendingPathComponent(fileNamed)
        try? text.write(to: file, atomically: false, encoding: String.Encoding.utf8)
    }
}
