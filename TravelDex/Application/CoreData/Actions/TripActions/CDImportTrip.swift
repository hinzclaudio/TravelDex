//
//  CDImportTrip.swift
//  TravelDex
//
//  Created by Claudio Hinz on 25.09.22.
//

import UIKit
import CoreData
import ZIPFoundation



struct CDImportTrip: CDAction {
    
    let fileURL: URL
    let completion: (Result<Trip, Error>) -> Void
    
    func execute(in context: NSManagedObjectContext) throws {
        do {
            guard fileURL.startAccessingSecurityScopedResource()
            else { throw FileManagementError.unknown }
            defer { fileURL.stopAccessingSecurityScopedResource() }
            
            let fm = FileManager.default
            let tempDirURL = fm.temporaryDirectory
            let extractionURL = tempDirURL.appendingPathComponent(UUID().uuidString)
            try fm.unzipItem(at: fileURL, to: extractionURL)
            
            let contents: [String]
            if #available(iOS 16.0, *) {
                contents = try fm.contentsOfDirectory(atPath: extractionURL.path())
            } else {
                contents = try fm.contentsOfDirectory(atPath: extractionURL.path)
            }
            
            // Check if the zip contains a content.json
            guard contents.contains(ExportConstants.contentsFileName)
            else { throw FileManagementError.dataCorrupted }
            
            let contentsURL = extractionURL.appendingPathComponent(ExportConstants.contentsFileName)
            let contentsData = try Data(contentsOf: contentsURL)
            
            // Decode the export.
            let jsonCoder = JSONDecoder()
            jsonCoder.dateDecodingStrategy = .iso8601
            let export = try jsonCoder.decode(TripExport.self, from: contentsData)
            
            // Check if the imported IDs are unique. Otherwise throw an error
            guard try checkUnique(trip: export.id, in: context)
            else { throw FileManagementError.alreadyImported }
            
            let placesAreUnique = try export.places
                .map { try checkUnique(place: $0.id, in: context) }
                .filter { !$0 }.isEmpty
            guard placesAreUnique
            else { throw FileManagementError.alreadyImported }
            
            // This is where the actual import happens...
            let cdTrip = CDTrip(context: context)
            cdTrip.safeInitNeglectRelationShips(
                dummyBit: false,
                descr: export.descr,
                id: export.id,
                members: export.members,
                title: export.title,
                pinColorRed: Int16(Trip.defaultPinColorRed),
                pinColorGreen: Int16(Trip.defaultPinColorGreen),
                pinColorBlue: Int16(Trip.defaultPinColorBlue)
            )
            
            export.places
                .forEach { placeExport in
                    let possibleJpegFile = placeExport.id.uuidString + ".jpg"
                    var pictureData: Data?
                    if contents.contains(possibleJpegFile),
                       let data = try? Data(contentsOf: extractionURL.appendingPathComponent(possibleJpegFile)),
                       UIImage(data: data) != nil {
                        pictureData = data
                    }
                    
                    let cdPlace = CDVisitedPlace(context: context)
                    let cdLoc = try! fetchSimilarLocation(
                        coordinate: Coordinate(
                            latitude: placeExport.locationLatitude,
                            longitude: placeExport.locationLongitude
                        ),
                        in: context
                    )
                    cdPlace.safeInit(
                        id: placeExport.id,
                        text: placeExport.text,
                        pictureData: pictureData,
                        start: placeExport.start,
                        end: placeExport.end,
                        location: cdLoc ?? CDLocation(context: context),
                        trip: cdTrip
                    )
                    cdPlace.location.safeInitNeglectRelationShips(
                        id: cdLoc?.id ?? UUID(),
                        latitude: cdLoc?.latitude ?? placeExport.locationLatitude,
                        longitude: cdLoc?.longitude ?? placeExport.locationLongitude,
                        name: cdLoc?.name ?? placeExport.locationName,
                        region: cdLoc?.region ?? placeExport.locationRegion,
                        country: cdLoc?.country ?? placeExport.locationCountry,
                        timezoneIdentifier: cdLoc?.timezoneIdentifier ?? placeExport.locationTimezone
                    )
                }
            
            let trip = cdTrip.pureRepresentation
            DispatchQueue.main.async {
                completion(.success(trip))
            }
            
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
    
}
