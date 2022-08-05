//
//  FileManagerExt.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation



extension FileManager {
    
    func ensureDirectoryExists(at url: URL) throws {
        var isDir: ObjCBool = false
        let _ = fileExists(atPath: url.path, isDirectory: &isDir)
        guard !isDir.boolValue else { return }
        try createDirectory(at: url, withIntermediateDirectories: true)
    }
    
}
