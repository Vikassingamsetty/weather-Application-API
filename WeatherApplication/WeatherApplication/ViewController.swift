//
//  ViewController.swift
//  WeatherApplication
//
//  Created by Srans022019 on 14/05/20.
//  Copyright © 2020 vikas. All rights reserved.
//

import UIKit
import Alamofire

struct WeatherCondition : Codable {
    let location : Weather
    let current : Current
}

struct Weather : Codable {
    let name : String
    let latitude : String
    let longitude : String
    
    enum CodingKeys : String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "lon"
    }
}

struct Current : Codable {
    let weather_descriptions : [String]
    let temperature : UInt8
}


class ViewController: UIViewController {

    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var weatherDisplayLbl: UILabel!
    
    var weatherData : WeatherCondition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onCheckLocation(_ sender: Any) {
        
        weatherURLInfo()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func weatherURLInfo() {
        
        if let url = URL(string: "http://api.weatherstack.com/current?access_key=45508b702189b045276769f62a8cdee5&query=\(locationTF.text!.replacingOccurrences(of: " ", with: "%20"))") {
            
            AF.request(url).validate().responseJSON { (response) in
                
                guard let responses = response.data else{
                    return
                }
                
                do{
                    
                    self.weatherData = try JSONDecoder().decode(WeatherCondition.self, from: responses)
                    
                    print(self.weatherData!.current.weather_descriptions[0])
                    print(self.weatherData!.current.temperature)
                    print(self.weatherData!.location.name)
                    print(self.weatherData!.location.latitude)
                    print(self.weatherData!.location.longitude)
                    
                    let temp = self.weatherData!.location.name + " has " + "\(self.weatherData!.current.temperature)°C with " + self.weatherData!.current.weather_descriptions[0] + " weather"
                    
                    let latLong = " latitude :" + self.weatherData!.location.latitude + " and longitude :" + self.weatherData!.location.longitude
                    
                    print( temp + latLong)
                    
                    let main = temp+latLong
                    
                    self.weatherDisplayLbl.text = main
                    
                }catch{
                    print("Enter correct name")
                }
                
            }
            
        }else {
            print("Error in server Data")
        }
        
    }

}

