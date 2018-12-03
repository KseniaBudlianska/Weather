//
//  Weather.swift
//  Weather
//
//  Created by Ksenia Budlianska on 26.11.18.
//  Copyright © 2018 Ksenia Budlianska. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let cityName: String
    let temp: Double
    let description: String
    let icon: String
    
    init(cityName: String, temp: Double, description: String, icon: String) {
        self.cityName = cityName
        self.temp = temp
        self.description = description
        self.icon = icon
    }
}
