//
//  LocationService.swift
//  chef
//
//  Created by 大谷悦志 on 2019/11/27.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

import Foundation
import CoreLocation

//MARK: Protocols
protocol LocationDelegate: class {
    func updateLocation(placemark: CLPlacemark)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    //MARK: Properties
    private var locationManager: CLLocationManager!
    var UserLocation : CLLocation?
    weak var delegate: LocationDelegate?
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    //MARK: Actions
    func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = 10
        locationManager.requestWhenInUseAuthorization()

        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .notDetermined:
            print("User did not selecte for this app ")
        case .denied:
            print("location service is invalid")
        case .restricted:
            print("this app cannot use location service")
        case .authorizedAlways:
            print("app always use location service")
            locationManager.startUpdatingLocation()
        case.authorizedWhenInUse:
            print("app can use location service when this app is awaken")
            locationManager.startUpdatingLocation()
        @unknown default:
            print("error")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.first
        
        guard let locate = location else {
            return
        }
        self.UserLocation = locate
        CLGeocoder().reverseGeocodeLocation(locate) {(placemarks, error) in
            guard let placemarks = placemarks,
                    let placemark = placemarks.first else {
                return
            }
            self.delegate?.updateLocation(placemark: placemark)
        }
    }
}
