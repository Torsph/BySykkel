//
//  MapLocation.swift
//  BySykkel
//
//  Created by Torp, Thomas on 16/09/2018.
//  Copyright © 2018 Torp. All rights reserved.
//

import Foundation
import MapKit

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
