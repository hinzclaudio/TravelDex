/*
 This file is used to inject some data into the app before taking screenshots.
 */

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var dependencies: AppDependencies!
    private var appCoordinator: AppCoordinator!


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        self.window = UIWindow(windowScene: windowScene)
        let appDependencies = DefaultAppDependencies()
        self.dependencies = appDependencies
        setupMockData(using: appDependencies, randomIds: false)
        
        self.appCoordinator = AppCoordinator(window: window, dependencies: dependencies)
        self.appCoordinator.start()
        
        window!.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        // TODO: Save the applications state
    }
    
    func setupMockData(using dependencies: DefaultAppDependencies, randomIds: Bool) {
        let trip1 = Trip(
            id: randomIds ? UUID() : TripID(uuidString: "afb5b5f4-a608-4f44-bc50-eac56e0b116d")!,
            title: Localizable.mockedTripTitle1,
            descr: Localizable.mockedTripDescr1,
            members: Localizable.mockedTripMembers1,
            visitedLocations: [],
            start: .now,
            end: .now,
            pinColorRed: Trip.defaultPinColorRed,
            pinColorGreen: Trip.defaultPinColorGreen,
            pinColorBlue: Trip.defaultPinColorBlue
        )
        let trip2 = trip1.cloneBuilder()
            .with(id: randomIds ? UUID() : TripID(uuidString: "360855b1-8ec1-46db-aa91-d7b886f565bc")!)
            .with(title: Localizable.mockedTripTitle2)
            .with(descr: Localizable.mockedTripDescr2)
            .with(members: Localizable.mockedTripMembers2)
            .build()!
        let trip3 = trip1.cloneBuilder()
            .with(id: randomIds ? UUID() : TripID(uuidString: "74093a99-7853-4d90-9aff-ef9fc724de1d")!)
            .with(title: Localizable.mockedTripTitle3)
            .with(descr: Localizable.mockedTripDescr3)
            .with(members: Localizable.mockedTripMembers3)
            .build()!
        
        let bochum  = Location(
            id: randomIds ? UUID() : LocationID(uuidString: "22252040-df98-4dee-a05f-3c8120d7e7ae")!,
            name: "Bochum", region: "Ruhrgebiet", country: "Germany",
            coordinate: Coordinate(latitude: 51.483403, longitude: 7.218664)
        )
        let essen = Location(
            id: randomIds ? UUID() : LocationID(uuidString: "2a0c179b-c6ad-4aa9-aa46-f0db4717c073")!,
            name: "Essen", region: "Ruhrgebiet", country: "Germany",
            coordinate: Coordinate(latitude: 51.457310, longitude: 7.011961)
        )
        let dortmund = Location(
            id: randomIds ? UUID() : LocationID(uuidString: "9ea2fe1f-6780-413d-99aa-4b45cc588806")!,
            name: "Dortmund", region: "Ruhrgebiet", country: "Germany",
            coordinate: Coordinate(latitude: 51.513784, longitude: 7.464763)
        )
        let witten = Location(
            id: randomIds ? UUID() : LocationID(uuidString: "b67f62f5-f871-405e-8284-10c241781120")!,
            name: "Witten", region: "Ruhrgebiet", country: "Germany",
            coordinate: Coordinate(latitude: 51.439118, longitude: 7.336871)
        )
        
        [trip1, trip2, trip3]
            .map { CDUpdateTrip(trip: $0) }
            .forEach(dependencies.cdStack.dispatch(_:))
        dependencies.cdStack.dispatch(
            CDUpdateLocations(locations: [bochum, essen, dortmund, witten])
        )
        
        let day = TimeInterval(86400)
        let visitedWitten = VisitedPlace(
            id: VisitedPlaceID(uuidString: "630e417d-b2e3-4dee-808c-c6da29845977")!,
            text: nil,
            picture: nil,
            start: .now.addingTimeInterval(-7 * day),
            end: .now.addingTimeInterval(-5 * day),
            tripId: trip3.id,
            locationId: witten.id
        )
        let visitedEssen = VisitedPlace(
            id: VisitedPlaceID(uuidString: "87796c9e-ccbc-4a32-9e1e-bf415c420967")!,
            text: nil,
            picture: nil,
            start: .now.addingTimeInterval(-5 * day),
            end: .now.addingTimeInterval(-3 * day),
            tripId: trip3.id,
            locationId: essen.id
        )
        let visitedDortmund = VisitedPlace(
            id: VisitedPlaceID(uuidString: "ce1e698b-a7f7-4d0b-8fcc-3928b9b31cd8")!,
            text: nil,
            picture: nil,
            start: .now.addingTimeInterval(-3 * day),
            end: .now.addingTimeInterval(-2 * day),
            tripId: trip3.id,
            locationId: dortmund.id
        )
        let visitedBochum = VisitedPlace(
            id: VisitedPlaceID(uuidString: "216dcd52-2732-4bbf-b637-b13650f24589")!,
            text: nil,
            picture: nil,
            start: .now.addingTimeInterval(-2 * day),
            end: .now,
            tripId: trip3.id,
            locationId: bochum.id
        )
        
        [visitedEssen, visitedBochum, visitedWitten, visitedDortmund]
            .map { CDUpdatePlace(place: $0) }
            .forEach(dependencies.cdStack.dispatch(_:))
    }

}

