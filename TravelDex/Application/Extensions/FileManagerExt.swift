//
//  FileManagerExt.swift
//  TravelDex
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation




enum FileManagementError: Error {
    case missingDirectory
}


extension FileManager {
    
    func getDocumentDirectoryURL() throws -> URL {
        if let url = urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            throw FileManagementError.missingDirectory
        }
    }
    
    func ensureDirectoryExists(at url: URL) throws {
        var isDir: ObjCBool = false
        let _ = fileExists(atPath: url.path, isDirectory: &isDir)
        guard !isDir.boolValue else { return }
        try createDirectory(at: url, withIntermediateDirectories: true)
    }
    
}
