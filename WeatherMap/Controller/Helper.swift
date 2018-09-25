//
//  Helper.swift
//  WeatherMap
//
//  Created by Данил on 9/24/18.
//  Copyright © 2018 Dareniar. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MapKit
import JGProgressHUD

class Helper {
    
    static var weatherJSON: JSON?
    
    static var latitude: Double?
    
    static var longitude: Double?

    static func fetchWeatherData(destination: WeatherViewController) {
        
        let url = "https://api.darksky.net/forecast/7b98a80047308516204ad5d82bb210b7/\(Helper.latitude!),\(Helper.longitude!)"
        
        let hud = JGProgressHUD(style: .light)
        hud.contentInsets = UIEdgeInsets(top: 60, left: 60, bottom: 60, right: 60)
        hud.textLabel.text = "Loading"
        hud.show(in: destination.view)
            
        Alamofire.request(url, method: .get, parameters: ["units":"si"]).responseJSON {
            
            response in
            if response.result.isSuccess {
                
                weatherJSON = JSON(response.result.value!)
                
                guard let weatherJSON = weatherJSON else { return }
                
                hud.dismiss(animated: true)
                
                Helper.update(destination: destination, with: weatherJSON)
                
            } else {
                
                print("Error \(String(describing: response.result.error)).")
                
                hud.dismiss(animated: true)
                
                let errorHUD = JGProgressHUD(style: .light)
                errorHUD.contentInsets = UIEdgeInsets(top: 60, left: 60, bottom: 60, right: 60)
                errorHUD.indicatorView = JGProgressHUDErrorIndicatorView()
                errorHUD.textLabel.text = "Lost Connection"
                errorHUD.show(in: destination.view)
                errorHUD.dismiss(afterDelay: 3.0)
                destination.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    static func getDayOfWeek(with date: Date) -> String {
        
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: date)
        
        switch weekDay {
        case 1:
            return "Mon"
        case 2:
            return "Tue"
        case 3:
            return "Wed"
        case 4:
            return "Thu"
        case 5:
            return "Fri"
        case 6:
            return "Sat"
        default :
            return "Sun"
        }
    }
    
    static func getImage(with icon: String) -> UIImage {
        
        switch (icon) {
            
        case "clear-day", "clear-night" :
            return UIImage(named: "Sunny")!
            
        case "rain":
            return UIImage(named: "Rain")!
            
            
        case "cloudy":
            return UIImage(named: "Cloudy")!
            
        case "thunderstorm":
            return UIImage(named: "Thunder")!
            
        default :
            return UIImage(named: "Cloud")!
        }
    }
    
    static func parseAddress(selectedItem: MKPlacemark) -> String {
        
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        
        let secondComma = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? ", " : ""
        
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondComma,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
    static func update(destination: WeatherViewController, with json: JSON) {
        
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: Helper.latitude!, longitude: Helper.longitude!)) {
            (placemarks, geocoderError) in
            
            if let placemarks = placemarks {
                let pm = placemarks[0]
                var title = parseAddress(selectedItem: MKPlacemark(placemark: pm))
                if title != "" {
                    if !title.starts(with: ", ") {
                        destination.navigationItem.title = title
                    } else {
                        title.removeFirst(2)
                        destination.navigationItem.title = title
                    }
                } else {
                    destination.navigationItem.title = "Lat: ~\(Int(Helper.latitude!)), Lon: ~\(Int(Helper.longitude!))"
                }
            }
        }
        
        destination.conditionImage.image = Helper.getImage(with: json["currently"]["icon"].stringValue)
        destination.temperatureLabel.text = "\(json["currently"]["temperature"].intValue) °C"
        destination.windSpeedLabel.text = "\(json["currently"]["windSpeed"].intValue)  m/s"
        destination.humidityLabel.text = "\(Int(json["currently"]["humidity"].doubleValue * 100))%"
        destination.precipLabel.text = "\(Int((json["currently"]["precipProbability"].doubleValue) * 100))%"
        
        destination.conditionImage1.image = Helper.getImage(with: json["daily"]["data"][0]["icon"].stringValue)
        destination.temperatureLabel1.text = "\(Int((json["daily"]["data"][0]["temperatureHigh"].doubleValue + json["daily"]["data"][0]["temperatureLow"].doubleValue))/2) °C"
        destination.dayLabel1.text = Helper.getDayOfWeek(with: Date(timeIntervalSince1970: TimeInterval(json["daily"]["data"][0]["time"].intValue)))
        
        destination.conditionImage2.image = Helper.getImage(with: json["daily"]["data"][1]["icon"].stringValue)
        destination.temperatureLabel2.text = "\(Int((json["daily"]["data"][1]["temperatureHigh"].doubleValue + json["daily"]["data"][1]["temperatureLow"].doubleValue))/2) °C"
        destination.dayLabel2.text = Helper.getDayOfWeek(with: Date(timeIntervalSince1970: TimeInterval(json["daily"]["data"][1]["time"].intValue)))
        
        destination.conditionImage3.image = Helper.getImage(with: json["daily"]["data"][2]["icon"].stringValue)
        destination.temperatureLabel3.text = "\(Int((json["daily"]["data"][2]["temperatureHigh"].doubleValue + json["daily"]["data"][2]["temperatureLow"].doubleValue))/2) °C"
        destination.dayLabel3.text = Helper.getDayOfWeek(with: Date(timeIntervalSince1970: TimeInterval(json["daily"]["data"][2]["time"].intValue)))
        
        destination.conditionImage4.image = Helper.getImage(with: json["daily"]["data"][3]["icon"].stringValue)
        destination.temperatureLabel4.text = "\(Int((json["daily"]["data"][3]["temperatureHigh"].doubleValue + json["daily"]["data"][3]["temperatureLow"].doubleValue))/2) °C"
        destination.dayLabel4.text = Helper.getDayOfWeek(with: Date(timeIntervalSince1970: TimeInterval(json["daily"]["data"][3]["time"].intValue)))
        
        destination.conditionImage5.image = Helper.getImage(with: json["daily"]["data"][4]["icon"].stringValue)
        destination.temperatureLabel5.text = "\(Int((json["daily"]["data"][4]["temperatureHigh"].doubleValue + json["daily"]["data"][4]["temperatureLow"].doubleValue))/2) °C"
        destination.dayLabel5.text = Helper.getDayOfWeek(with: Date(timeIntervalSince1970: TimeInterval(json["daily"]["data"][4]["time"].intValue)))
    }
}

