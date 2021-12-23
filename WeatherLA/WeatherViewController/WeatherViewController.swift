//
//  WeatherViewController.swift
//  WeatherLA
//
//  Created by Vladislav on 22.12.2021.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController {
// Outlets for all labels and ImageView
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Calling our functions
        requestWeather()
        requestDay()
    }
    // Defing request to get weather
    private func requestWeather() {
        AF
            .request("https://api.openweathermap.org/data/2.5/weather?id=5368361&appid=d7a6b9add4b8e5439475eeb1317cec30&units=metric")
            .responseJSON {
                response in
                if let weatherResponse = try? response.result.get() {
                    // Stores data in JSON format
                    let jsonResponse = JSON(weatherResponse)
                    // We get access to nested folder
                    let jsonWeather = jsonResponse["weather"].array![0]
                    let jsonTemp =  jsonResponse["main"]
                    // Converting to non JSON values
                    let jsonIconName = jsonWeather["icon"].stringValue
                    let jsonLocationName = jsonResponse["name"].stringValue
                    let jsonCondition = jsonWeather["main"].stringValue
                    // Accesing nested "folder" by typing ["main folder"][sub folder]
                    let jsonWind = jsonResponse["wind"]["speed"].stringValue
                    let jsonHum = jsonTemp["humidity"].stringValue
                    
                    // Assigning values to image and labels
                    self.locationLabel.text = jsonLocationName
                    // We use UIImage(named: "string") so we can assign the image we need depending on current condition
                    self.conditionImageView.image = UIImage(named: jsonIconName)
                    self.conditionLabel.text = jsonCondition
                    // This way we can show our value in non-decimal format
                    self.temperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
                    self.windSpeedLabel.text = "\(jsonWind) km/h"
                    self.humidityLabel.text = "\(jsonHum) %"
                }
            }
    }
    // Day of the week function
    func requestDay() {
        let date = Date()
        let formatter = DateFormatter()
        // This format shows only day of the week
        formatter.dateFormat = "EEEE"
        let result = formatter.string(from: date)
        // Assigning current day of the week to the label
        dateLabel.text! = result
    }
}
