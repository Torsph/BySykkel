import Foundation
import MapKit

public struct Stations: Decodable {
    public let stations: [Station]
}

public struct Station: Decodable {
    public let id: Int
    public let title: String
    public let subtitle: String
    public let number_of_locks: Int
    public let center: Location
    public let bounds: [Location]
    public var availability: Availability?
}

public struct Availability: Decodable {
    public let bikes: Int
    public let locks: Int
}

public struct Location: Decodable {
    public let latitude: Double
    public let longitude: Double
}

public struct StationsAvailability: Decodable {
    public let stations: [StationAvailability]
}

public struct StationAvailability: Decodable {
    public let id: Int
    public let availability: Availability?
}

class MapLocation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    var title: String? {
        return "\(station.id) - \(station.title)"
    }
    var subtitle: String? {
        return "Locks: \(station.number_of_locks) - Free/Occupied: \(station.availability?.bikes ?? 0)/\(station.availability?.locks ?? 0)"
    }
    let station: Station

    init(station: Station) {
        self.station = station
        coordinate = CLLocationCoordinate2D(latitude: station.center.latitude, longitude: station.center.longitude)
    }
}
