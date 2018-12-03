//
//  ViewController.swift
//  Weather
//
//  Created by Ksenia Budlianska on 26.11.18.
//  Copyright © 2018 Ksenia Budlianska. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WeatherServiceDelegate, UITableViewDataSource, UITableViewDelegate {
    private let weatherService = WeatherService()
    private var data: [Weather] = []
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.weatherService.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //TODO: Check file -> if empty ignore, if not empty show content
    }

    @IBAction func selectCityButtonClick(_ sender: Any) {
        openCityAlert()
    }
    
    func openCityAlert() {
        // Create Alert Controller
        let alert = UIAlertController(title: "City", message: "Enter name of the City please.", preferredStyle: UIAlertController.Style.alert)
        
        // Create Cancel Action
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //Create OK Action
        let ok = UIAlertAction(title: "Ok", style: .default) {
            (action: UIAlertAction) -> Void in
            let textField = alert.textFields?[0]
            if (textField?.text != "") {
                let cityName = textField?.text!
                self.weatherService.getWeather(city: cityName!)
            }
        }
        
        // Add Action
        alert.addAction(cancel)
        alert.addAction(ok)
        
        // Add Text Field
        alert.addTextField { (textField: UITextField) -> Void in
            textField.placeholder = "City Name"
        }
        
        // Present Alert Controller
        self.present(alert, animated: true, completion: nil)
    }
    
    func setWeather(weather: Weather) {
        print("VC City: \(weather.cityName) Temp: \(weather.temp) Description: \(weather.description)")
        updateData(weather: weather)
        //Add weather in View Controller
        updateTableView(weather: weather)
        
        //TODO: add value to array and save to file
    }
    
    func updateData(weather: Weather) {
        tempLabel.isHidden = false
        cityLabel.isHidden = false
        descriptionLabel.isHidden = false
        tableView.isHidden = false
        
        //Update labels
        self.tempLabel.text = "\(round(weather.temp))°"
        self.descriptionLabel.text = weather.description
        self.cityLabel.text = ""
        self.cityButton.setTitle(weather.cityName, for: .normal)
        loadImage(url: "http://openweathermap.org/img/w/\(weather.icon).png")
    }
    
    func showWeatherErrorWithMessage(city: String, message: String) {
        let alert = UIAlertController(title: "Error", message: "Incorrect city: \(city)", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")!
        let weather = data[indexPath.row]
        cell.textLabel?.text = weather.cityName
        cell.detailTextLabel?.text = "\(weather.temp)"
        return cell //4.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weather = data[indexPath.row]
        updateData(weather: weather)
        print("Clicked on: \(weather.cityName)")
    }
    
    func updateTableView(weather: Weather) {
        data.append(weather)
        DispatchQueue.main.async { () -> Void in
            self.tableView.reloadData()
        }
        tableView.resignFirstResponder()
    }
    
    func loadImage(url: String) {
        let url = URL(string: url)!
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                     self.iconImage.image = image
                }
            }
        }
        task.resume()
    }
}

