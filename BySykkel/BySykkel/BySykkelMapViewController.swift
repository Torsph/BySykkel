//
//  BySykkelMapViewController.swift
//  BySykkel
//
//  Created by Torp, Thomas on 14/09/2018.
//  Copyright © 2018 Torp. All rights reserved.
//

import UIKit
import MapKit

class BySykkelMapViewController: UIViewController {
    lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        return mapView
    }()

    let viewModel: BySykkelViewModel

    public init(viewModel: BySykkelViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.delegate = self
        removeAnnotations()
        addAnnotations()
    }

    func setup() {
        title = "Map"
        tabBarItem.image = UIImage(named: "map_marker")
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
            ])

        centerMap(to: .oslo)
    }

    private func centerMap(to location: CLLocation) {
        let regionRadius: CLLocationDistance = 7000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    private func addAnnotations() {
        guard let stations = viewModel.stations else { return }
        let pins = stations.map { (station) -> MapLocation in
            MapLocation(station: station)
        }

        mapView.addAnnotations(pins)
    }

    private func removeAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }
}

extension BySykkelMapViewController: BySykkelViewModelDelegate {
    public func didLoad() {
        DispatchQueue.main.async { [weak self] in
            self?.removeAnnotations()
            self?.addAnnotations()
        }
    }

    public func didFail(with error: Error) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

extension BySykkelMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MapLocation else { return nil }

        let identifier = "marker"
        return {
            guard let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView else {
                let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.rightCalloutAccessoryView = UIButton(type: .custom)
                return view
            }
            dequeuedView.annotation = annotation
            return dequeuedView
        }()
    }
}
