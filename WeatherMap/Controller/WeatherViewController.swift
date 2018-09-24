//
//  WeatherViewController.swift
//  WeatherMap
//
//  Created by Данил on 9/24/18.
//  Copyright © 2018 Dareniar. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipLabel: UILabel!
    
    @IBOutlet weak var conditionImage1: UIImageView!
    @IBOutlet weak var temperatureLabel1: UILabel!
    @IBOutlet weak var dayLabel1: UILabel!
    
    @IBOutlet weak var conditionImage2: UIImageView!
    @IBOutlet weak var temperatureLabel2: UILabel!
    @IBOutlet weak var dayLabel2: UILabel!
    
    @IBOutlet weak var conditionImage3: UIImageView!
    @IBOutlet weak var temperatureLabel3: UILabel!
    @IBOutlet weak var dayLabel3: UILabel!
    
    @IBOutlet weak var conditionImage4: UIImageView!
    @IBOutlet weak var temperatureLabel4: UILabel!
    @IBOutlet weak var dayLabel4: UILabel!
    
    @IBOutlet weak var conditionImage5: UIImageView!
    @IBOutlet weak var temperatureLabel5: UILabel!
    @IBOutlet weak var dayLabel5: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backButtonTapped(_ sender: Any) {
        print("Hir")
        dismiss(animated: true, completion: nil)
    }

}
