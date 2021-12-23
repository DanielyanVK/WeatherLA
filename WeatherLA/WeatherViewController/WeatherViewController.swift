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
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        requestWeather()
        requestDay()
    }
    // Define request
    private func requestWeather() {
        AF
            .request("https://api.openweathermap.org/data/2.5/weather?id=5368361&appid=d7a6b9add4b8e5439475eeb1317cec30&units=metric")
            .responseJSON {
                response in
                if let weatherResponse = try? response.result.get() {
                    let jsonResponse = JSON(weatherResponse)
                    let jsonWeather = jsonResponse["weather"].array![0]
                    let jsonTemp =  jsonResponse["main"]
                    let jsonIconName = jsonWeather["icon"].stringValue
                    let jsonLocationName = jsonResponse["name"].stringValue
                    let jsonCondition = jsonWeather["main"].stringValue
                    let jsonWind = jsonResponse["wind"]["speed"].stringValue
                    let jsonHum = jsonTemp["humidity"].stringValue
                    
                    self.locationLabel.text = jsonLocationName
                    self.conditionImageView.image = UIImage(named: jsonIconName)
                    self.conditionLabel.text = jsonCondition
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
        formatter.dateFormat = "EEEE"
        let result = formatter.string(from: date)
        dateLabel.text! = result
    }
}
