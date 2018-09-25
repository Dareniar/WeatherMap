//
//  SearchTableViewController.swift
//  WeatherMap
//
//  Created by Данил on 9/24/18.
//  Copyright © 2018 Dareniar. All rights reserved.
//

import UIKit
import MapKit

class SearchTableViewController: UITableViewController {
    
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView?
    var handleMapSearchDelegate: HandleMapSearch?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = Helper.shared.parseAddress(selectedItem: selectedItem)
        
        let orangeView = UIView()
        orangeView.backgroundColor = UIColor.orange
        cell.selectedBackgroundView = orangeView
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.recenterMapView(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
    }
}

extension SearchTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else { return }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else { return }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}
