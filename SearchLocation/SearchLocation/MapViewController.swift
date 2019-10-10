//
//  MapViewController.swift
//  SearchLocation
//
//  Created by Kazushi Uemura on 2019/10/05.
//  Copyright © 2019 Kazushi Uemura. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    var text: String?
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "地図"
        let coordinate = CLLocationCoordinate2DMake(35.6598051, 139.7036661) // 渋谷ヒカリエ
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000.0, longitudinalMeters: 1000.0) // 1km * 1km
        
        Map.search(query: text ?? "", region: region) { (result) in
            switch result {
            case .success(let mapItems):
                for map in mapItems {
                    print("name: \(map.name ?? "no name")")
                    print("coordinate: \(map.placemark.coordinate.latitude) \(map.placemark.coordinate.latitude)")
                    print("address \(map.placemark.address)")
                    let annotation = MKPointAnnotation()
                    annotation.title = map.name
                    annotation.coordinate = map.placemark.coordinate
                    self.mapView.addAnnotation(annotation)
                    var region:MKCoordinateRegion = self.mapView.region
                    region.center = map.placemark.coordinate
                    region.span.latitudeDelta = 0.02
                    region.span.longitudeDelta = 0.02
                    
                    self.mapView.setRegion(region,animated:true)
                }
            case .failure(let error):
                print("error \(error.localizedDescription)")
            }
        }
    }
}

struct Map {
    enum Result<T> {
        case success(T)
        case failure(Error)
    }
    
    static func search(query: String, region: MKCoordinateRegion? = nil, completionHandler: @escaping (Result<[MKMapItem]>) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        if let region = region {
            request.region = region
        }
        
        MKLocalSearch(request: request).start { (response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            completionHandler(.success(response?.mapItems ?? []))
        }
    }
}

extension MKPlacemark {
    var address: String {
        let components = [self.administrativeArea, self.locality, self.thoroughfare, self.subThoroughfare]
        return components.compactMap { $0 }.joined(separator: "")
    }
}
