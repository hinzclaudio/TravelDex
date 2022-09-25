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
            let fileName = cdTrip.title.lettersOnly + ".tdex"
            let temporaryDirURL = fm.temporaryDirectory
            let archiveURL = temporaryDirURL.appendingPathComponent(fileName)
            
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
            let srcDirURL = temporaryDirURL.appendingPathComponent(UUID().uuidString)
            try fm.ensureDirectoryExists(at: srcDirURL)
            
            // First, let's write the actual json to disk.
            let jsonCoder = JSONEncoder()
            jsonCoder.dateEncodingStrategy = .iso8601
            jsonCoder.outputFormatting = [.prettyPrinted, .withoutEscapingSlashes]
            let jsonData = try jsonCoder.encode(exportFormat)
            let contentsURL = srcDirURL.appendingPathComponent(ExportConstants.contentsFileName)
            try jsonData.write(to: contentsURL)
            
            // Now we want to export all of the trips pictures.
            var imgDataURLs = [URL]()
            try cdTrip.visitedPlaces
                .asArray(of: CDVisitedPlace.self)!
                .forEach { cdPlace in
                    guard let data = cdPlace.pictureData else { return }
                    let dataURL = srcDirURL.appendingPathComponent(cdPlace.id.uuidString + ".jpg")
                    try data.write(to: dataURL)
                    imgDataURLs.append(dataURL)
                }
            
            // Actually zip the directory and delete the src dir.
            guard let archive = Archive(url: archiveURL, accessMode: .create)
            else { throw FileManagementError.unknown }
            try archive.addEntry(with: ExportConstants.contentsFileName, fileURL: contentsURL)
            try imgDataURLs
                .forEach { imgURL in
                    try archive.addEntry(with: imgURL.lastPathComponent, fileURL: imgURL)
                }
            
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
