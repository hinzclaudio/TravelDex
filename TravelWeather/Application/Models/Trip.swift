//
//  Trip.swift
//  TravelWeather
//
//  Created by Claudio Hinz on 05.08.22.
//

import Foundation



struct Trip: Equatable, WithAutoBuilder {
    // sourcery:begin: nonDefaultBuilderProperty
    let id: UUID
    let title: String
    let descr: String?
    let members: String?
    let visitedLocations: [UUID]
    let start: Date?
    let end: Date?
    // sourcery:end: nonDefaultBuilderProperty

// sourcery:inline:auto:Trip.AutoBuilderInit
    // MARK: - Init Buildable
    init(
        id: UUID, 
        title: String, 
        descr: String? = nil, 
        members: String? = nil, 
        visitedLocations: [UUID], 
        start: Date? = nil, 
        end: Date? = nil
    )
    {
        self.id = id
        self.title = title
        self.descr = descr
        self.members = members
        self.visitedLocations = visitedLocations
        self.start = start
        self.end = end
    }
    static var builder: TripBuilder {
        TripBuilder()
    }
    func cloneBuilder() -> TripBuilder {
        Trip.builder
            .with(id: self.id)
            .with(title: self.title)
            .with(descr: self.descr)
            .with(members: self.members)
            .with(visitedLocations: self.visitedLocations)
            .with(start: self.start)
            .with(end: self.end)
    }
// sourcery:end
}
// sourcery:inline:after-auto:Trip.AutoBuilder-Builder
// MARK: - Builder
class TripBuilder {


    private(set) var id: UUID?


    private(set) var title: String?


    private(set) var descr: String??


    private(set) var members: String??


    private(set) var visitedLocations: [UUID]?


    private(set) var start: Date??


    private(set) var end: Date??

    func with(id: UUID) -> TripBuilder {
        self.id = id; return self
    }
    func with(title: String) -> TripBuilder {
        self.title = title; return self
    }
    func with(descr: String?) -> TripBuilder {
        self.descr = descr; return self
    }
    func with(members: String?) -> TripBuilder {
        self.members = members; return self
    }
    func with(visitedLocations: [UUID]) -> TripBuilder {
        self.visitedLocations = visitedLocations; return self
    }
    func with(start: Date?) -> TripBuilder {
        self.start = start; return self
    }
    func with(end: Date?) -> TripBuilder {
        self.end = end; return self
    }
    func build() -> Trip? {
        guard
            let id = self.id,
            let title = self.title,
            let descr = self.descr,
            let members = self.members,
            let visitedLocations = self.visitedLocations,
            let start = self.start,
            let end = self.end
        else { return nil }
        return Trip(
            id: id,
            title: title,
            descr: descr,
            members: members,
            visitedLocations: visitedLocations,
            start: start,
            end: end
        )
    }
}
// sourcery:end
