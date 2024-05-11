//
//  Location.swift
//  WhereIsTheRestroom
//
//  Created by Taewon Yoon on 5/11/24.
//

import UIKit
import CoreLocation
import SwiftUI
import NMapsMap

class Location: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    static let shared = Location()
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("설정 변경:\(manager.authorizationStatus)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
    
}

