//
//  CDExportTrip.swift
//  TravelDex
//
//  Created by Claudio Hinz on 24.09.22.
//

import Foundation
import CoreData
import ZIPFoundation



struct CDExportTrip: CDAction {
    
    let tripId: TripID
    let completion: (Result<URL, Error>) -> Void
    
    func execute(in context: NSManagedObjectContext) throws {
        guard let cdTrip = try fetchTrip(by: tripId, in: context)
        else {
            assertionFailure("Something's missing...")
            return
        }
        
        let exportFormat = try cdTrip.exportFormat(using: context)
        
        let fm = FileManager.default
        let fileName = cdTrip.title + ".tdex"
        let docDirURL = try fm.getDocumentDirectoryURL()
        let archiveURL = docDirURL.appendingPathExtension(fileName)
        
        // Remove any archives that were created previously
        let fileExists: Bool
        if #available(iOS 16.0, *) {
            fileExists = fm.fileExists(atPath: archiveURL.path())
        } else {
            fileExists = fm.fileExists(atPath: archiveURL.path)
        }
        if fileExists {
            try fm.removeItem(at: archiveURL)
        }
        
        // Create a temporary directory
        let srcDirURL = docDirURL.appendingPathExtension(UUID().uuidString)
        try fm.ensureDirectoryExists(at: srcDirURL)
        
        // When we are done, we want to delete the temp. directory
        defer { try? fm.removeItem(at: srcDirURL) }
        
        // Now we want to write all data to srcDirURL before zipping it.
        let jsonCoder = JSONEncoder()
        jsonCoder.dateEncodingStrategy = .iso8601
        jsonCoder.outputFormatting = .prettyPrinted
        let jsonData = try jsonCoder.encode(exportFormat)
        try jsonData.write(to: srcDirURL.appendingPathExtension("content.json"))
        
        // Actually zip the
        try fm.zipItem(at: srcDirURL, to: archiveURL)
        DispatchQueue.main.async {
            completion(.success(archiveURL))
        }
    }
    
}
