import XCTest
@testable import BySykkel
import MapKit

class MapLocationTests: XCTestCase {
    func testCorrectSetup() {
        let location = Location(latitude: 1.11, longitude: 2.22)
        let availability = Availability(bikes: 2, locks: 1)
        let station = Station(id: 123, title: "title", subtitle: "subtitle", number_of_locks: 3, center: location, bounds: [location], availability: availability)

        let mapLocation = MapLocation(station: station)

        XCTAssertEqual(mapLocation.title, "123 - title")
        XCTAssertEqual(mapLocation.subtitle, "Locks: 3 - Free/Occupied: 2/1")
        XCTAssertEqual(mapLocation.coordinate.latitude, station.center.latitude)
        XCTAssertEqual(mapLocation.coordinate.longitude, station.center.longitude)
    }

    func testCorrectFallbackValues() {
        let location = Location(latitude: 1.11, longitude: 2.22)
        let station = Station(id: 123, title: "title", subtitle: "subtitle", number_of_locks: 3, center: location, bounds: [location], availability: nil)

        let mapLocation = MapLocation(station: station)

        XCTAssertEqual(mapLocation.title, "123 - title")
        XCTAssertEqual(mapLocation.subtitle, "Locks: 3 - Free/Occupied: 0/0")
    }
}
