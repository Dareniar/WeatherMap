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

class Helper {
    
    static var weatherJSON: JSON?

    static func fetchWeatherData(latitude: Double, longitude: Double, completion: ( () -> ())?) {
        
        let url = "https://api.darksky.net/forecast/7b98a80047308516204ad5d82bb210b7/\(latitude),\(longitude)"
            
        Alamofire.request(url, method: .get, parameters: ["units":"si"]).responseJSON {
            
            response in
            if response.result.isSuccess {
                
                weatherJSON = JSON(response.result.value!)
                //print(weatherJSON)
                completion?()
                
            } else {
                print("Error \(String(describing: response.result.error)).")
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
    
    static func update(destination: WeatherViewController, with json: JSON) {
        
        destination.temperature = Int(json["currently"]["temperature"].doubleValue)
        destination.condition = json["currently"]["icon"].stringValue
        
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

