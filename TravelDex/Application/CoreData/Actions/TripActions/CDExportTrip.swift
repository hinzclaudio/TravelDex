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
        
        do {
            let exportFormat = try cdTrip.exportFormat(using: context)
            let fm = FileManager.default
            let fileName = cdTrip.title + ".tdex"
            let docDirURL = try fm.getDocumentDirectoryURL()
            let archiveURL = docDirURL.appendingPathComponent(fileName)
            
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
            let srcDirURL = docDirURL.appendingPathComponent(UUID().uuidString)
            try fm.ensureDirectoryExists(at: srcDirURL)
            
            // Now we want to write all data to srcDirURL before zipping it.
            let jsonCoder = JSONEncoder()
            jsonCoder.dateEncodingStrategy = .iso8601
            jsonCoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
            let jsonData = try jsonCoder.encode(exportFormat)
            let contentsURL = srcDirURL.appendingPathComponent("content.json")
            try jsonData.write(to: contentsURL)
            
            // Actually zip the directory and delete the src dir.
            guard let archive = Archive(url: archiveURL, accessMode: .create)
            else { throw FileManagementError.unknown }
            try archive.addEntry(with: "content.json", fileURL: contentsURL)
            try fm.removeItem(at: srcDirURL)
            
            DispatchQueue.main.async {
                completion(.success(archiveURL))
            }
            
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
    
}
