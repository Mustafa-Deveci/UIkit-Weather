//
//  ViewController.swift
//  FollowWeather
//
//  Created by mustafa deveci on 26.08.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet var tableView : UITableView!
    var models = [WeatherData.Main]()
    var weatherInf = [WeatherData.Weather]()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var current: WeatherData.Main?
    var sys: WeatherData.Sys?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(WeatherInfTableViewCell.nib(), forCellReuseIdentifier: WeatherInfTableViewCell.identifier)
        tableView.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        view.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocation()
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation() {
        
        guard let currentLocation = currentLocation else {
            return
        }
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=6d5b78e774aec529906499be68044a96"
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data , error == nil else {
                print("Error!")
                return
            }
            
            var json : WeatherData?
            do {
                json = try JSONDecoder().decode(WeatherData.self, from: data)
            }
            catch {
                print("error : \(error)")
                
            }
            
            guard let result = json else {
                return
            }
            
            let entries = result.main
            self.models.insert(contentsOf: [entries] , at: 0)
            let current = result.main
            self.current = current
            let sys = result.sys
            self.sys = sys
            self.weatherInf = result.weather
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.tableHeaderView = self.createTableHeader()
            }
            
            
        }).resume()
    }
    
    func createTableHeader() -> UIView {
        let headerVIew = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        
        headerVIew.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
        
        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width-20, height: headerVIew.frame.size.height/5))
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height, width: view.frame.size.width-20, height: headerVIew.frame.size.height/5))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 20+locationLabel.frame.size.height+summaryLabel.frame.size.height, width: view.frame.size.width-20, height: headerVIew.frame.size.height/2))
        
        headerVIew.addSubview(locationLabel)
        headerVIew.addSubview(tempLabel)
        headerVIew.addSubview(summaryLabel)
        
        tempLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        summaryLabel.textAlignment = .center
        
        locationLabel.text = sys?.country
        
        guard let currentWeather = self.current else {
            return UIView()
        }
        
        let feelsLikeCelsius = currentWeather.feels_like - 273.15
        let formattedFeelsLike = String(format: "%.2f", feelsLikeCelsius)
        summaryLabel.text = "\(formattedFeelsLike)°"
        
        let temperatureCelsius = currentWeather.temp - 273.15
        let formattedTemperature = String(format: "%.2f", temperatureCelsius)
        tempLabel.text = "\(formattedTemperature)°"
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 32)
        
        return headerVIew
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 0 {
                // collectiontableviewcell
                return 1
            }
            return models.count
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: WeatherInfTableViewCell.identifier, for: indexPath) as! WeatherInfTableViewCell
                cell.configure(with: weatherInf)
                cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
                return cell
            }

            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
            cell.configure(with: models[indexPath.row])
            cell.backgroundColor = UIColor(red: 52/255.0, green: 109/255.0, blue: 179/255.0, alpha: 1.0)
            return cell
        }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}

struct WeatherData: Codable {
    struct Coordinate: Codable {
        let lon: Double
        let lat: Double
    }
    
    struct Weather: Codable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct Main: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
    }
    
    struct Wind: Codable {
        let speed: Double
        let deg: Int
    }
    
    struct Rain: Codable {
        let h1: Double
        
        enum CodingKeys: String, CodingKey {
            case h1 = "1h"
        }
    }
    
    struct Clouds: Codable {
        let all: Int
    }
    
    struct Sys: Codable {
        let type: Int
        let id: Int
        let country: String
        let sunrise: Int
        let sunset: Int
    }
    
    let coord: Coordinate
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let rain: Rain?
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}
