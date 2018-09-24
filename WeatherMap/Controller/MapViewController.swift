//
//  MapViewController.swift
//  WeatherMap
//
//  Created by Данил on 9/24/18.
//  Copyright © 2018 Dareniar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var latitude: Double?
    var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func forecastButtonTapped(_ sender: Any) {
        
        longitude = Double(mapView.centerCoordinate.longitude)
        latitude = Double(mapView.centerCoordinate.latitude)
        performSegue(withIdentifier: "forecast", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! WeatherViewController
        
        if segue.identifier == "forecast" {
            
//
//            destinationVC.longitude = longitude
//            destinationVC.latitude = latitude
            destinationVC.navigationItem.title = "Latitude: ~\(latitude!.rounded()), Longitude: ~\(longitude!.rounded())"
            
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    @IBAction func locationButtonTapped(_ sender: Any) {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            mapView.centerCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        }
    }
}

//extension MapViewController: MKMapViewDelegate {
//
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        //centerAnnotation.coordinate = mapView.centerCoordinate
//    }
//
//}
