//
//  WeatherService.swift
//  Weather
//
//  Created by Ksenia Budlianska on 26.11.18.
//  Copyright © 2018 Ksenia Budlianska. All rights reserved.
//

import Foundation

protocol WeatherServiceDelegate {
    func setWeather(weather: Weather)
    func showWeatherErrorWithMessage(city: String, message: String)
}

class WeatherService {
    
    var delegate: WeatherServiceDelegate?
    let appId = "ef6cf72b9429e2c81de590948bb5b934"
    
    func getWeather(city: String) {
        let cityEscaped = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let path = "http://api.openweathermap.org/data/2.5/weather?q=\(cityEscaped!)&APPID=\(appId)&units=metric"
        let url = URL(string: path)
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
            }
            
            let json = try! JSON(data: data!)
            print(json)
            
            var statusCode = 0
            if let finalStatusCode = json["cod"].int {
                statusCode = finalStatusCode
            } else if let finalStatusCode = json["cod"].string {
                statusCode = Int(finalStatusCode)!
            }
            print("Weather status code: \(statusCode)")
            
            if statusCode == 200 {
                let lon = json["coord"]["lon"].double!
                let lat = json["coord"]["lat"].double!
                let temp = json["main"]["temp"].double!
                let name = json["name"].string!
                let description = json["weather"][0]["description"].string!
                let icon = json["weather"][0]["icon"].string!
                
                print(" >>>>> lon: \(lon) lat: \(lat) temp: \(temp) description \(description)")
                let weather = Weather(cityName: name, temp: temp, description: description, icon: icon)
                if (self.delegate != nil) {
                    DispatchQueue.main.async { () -> Void in
                        self.delegate?.setWeather(weather: weather)
                    }
                }
            } else {
                if (self.delegate != nil) {
                    DispatchQueue.main.async { () -> Void in
                        self.delegate?.showWeatherErrorWithMessage(city: city, message: "\(statusCode) Error")
                    }
                }
            }
        }
        task.resume()
    }
}
