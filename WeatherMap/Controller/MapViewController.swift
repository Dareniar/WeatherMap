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
import SwiftyJSON
import JGProgressHUD

protocol HandleMapSearch {
    func recenterMapView(placemark:MKPlacemark)
}

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var resultSearchController:UISearchController?
    
    var latitude: Double?
    var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchTable = storyboard!.instantiateViewController(withIdentifier: "SearchTableViewController") as! SearchTableViewController
        searchTable.mapView = mapView
        searchTable.handleMapSearchDelegate = self
        
        resultSearchController = UISearchController(searchResultsController: searchTable)
        resultSearchController?.searchResultsUpdater = searchTable
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        searchBar.searchBarStyle = .minimal
        searchBar.keyboardAppearance = .dark
        navigationItem.titleView = resultSearchController?.searchBar
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.orange
    }
    
    @IBAction func forecastButtonTapped(_ sender: Any) {
        
        longitude = Double(mapView.centerCoordinate.longitude)
        latitude = Double(mapView.centerCoordinate.latitude)
        performSegue(withIdentifier: "forecast", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! WeatherViewController
        
        let hud = JGProgressHUD(style: .light)
        hud.contentInsets = UIEdgeInsets(top: 60, left: 60, bottom: 60, right: 60)
        hud.textLabel.text = "Loading"
        hud.show(in: destinationVC.view)
        
        
        if segue.identifier == "forecast" {
            
            Helper.fetchWeatherData(latitude: latitude!, longitude: longitude!) {
                
                Helper.update(destination: destinationVC, with: Helper.weatherJSON!)
                
                destinationVC.navigationItem.title = "Lat: ~\(Int(self.latitude!)), Lon: ~\(Int(self.longitude!))"
                
                hud.dismiss(animated: true)
            }
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
            
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), span: span)
            mapView.setRegion(region, animated: true)
        }
    }
}

extension MapViewController: HandleMapSearch {
    func recenterMapView(placemark:MKPlacemark){
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}

