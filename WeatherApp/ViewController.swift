//
//  ViewController.swift
//  WeatherApp
//
//  Created by Mustafa Pekdemir on 22.03.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet var tableView: UITableView!
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var hourlyModels = [HourlyWeatherEntry]()
    var models = [DailyWeatherEntry]()
    var current: CurrentWeather?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
        tableView.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBlue
        view.backgroundColor = .systemBlue
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

        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        
        let url = "https://api.darksky.net/forecast/ddcc4ebb2a7c9930b90d9e59bda0ba7a/\(lat),\(long)?exclude=[flags,minutely]"
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                print("Something went wrong.")
                return
                }
            var json: WeatherResponse?
            do {
                json = try JSONDecoder().decode(WeatherResponse.self, from: data)
            } catch {
                print("Error: \(error)")
            }
            guard let result = json else {
                return
            }
            let entries = result.daily.data
            self.models.append(contentsOf: entries)
            
            let current = result.currently
            self.current = current
            self.hourlyModels = result.hourly.data
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.tableHeaderView = self.crateTableHeader()
            }
        }).resume()
        }
    
    func crateTableHeader() -> UIView {
        let headerView = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        headerView.backgroundColor = .systemBlue
        let locationLabel = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width - 20, height: headerView.frame.size.height / 5))
        let summaryLabel = UILabel(frame: CGRect(x: 10, y: 20 + locationLabel.frame.size.height, width: view.frame.size.width, height: headerView.frame.size.height / 5))
        let tempLabel = UILabel(frame: CGRect(x: 10, y: 20 + locationLabel.frame.size.height + summaryLabel.frame.size.height, width: view.frame.size.width - 20, height: headerView.frame.size.height / 2))
        headerView.addSubview(locationLabel)
        headerView.addSubview(tempLabel)
        headerView.addSubview(summaryLabel)
        tempLabel.textAlignment = .center
        summaryLabel.textAlignment = .center
        locationLabel.textAlignment = .center
        
        guard let currentWeather = self.current else {
            return UIView()
        }
        
        tempLabel.text = "\(currentWeather.temperature)°"
        tempLabel.contentMode = .center
        tempLabel.font = UIFont(name: "Helvetica-Bold", size: 28)
        locationLabel.text = "Ankara"
        locationLabel.contentMode = .center
        locationLabel.font = UIFont(name: "Helvetica-Bold", size: 35)
        summaryLabel.text = self.current?.summary
        summaryLabel.font = UIFont(name: "Helvetica", size: 30)
        summaryLabel.contentMode = .center

        
        return headerView
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            cell.backgroundColor = .systemBlue
            cell.configure(with: hourlyModels)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        cell.backgroundColor = .systemBlue
        cell.configure(with: models[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

struct WeatherResponse: Codable {
    let latitude: Float
    let longitude: Float
    let timezone: String
    let currently: CurrentWeather
    let hourly: HourlyWeather
    let daily: DailyWeather
    let offset: Float
}

struct CurrentWeather: Codable {
    let time: Int
    let summary: String
    let icon: String
    //let nearestStormDistance: Int
    //let nearestStormBearing: Int
    //let precipIntensity: Int
    //let precipProbability: Int
    let temperature: Double
    let apparentTemperature: Double
    let dewPoint: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windGust: Double
    let windBearing: Int
    let cloudCover: Double
    let uvIndex: Int
    let visibility: Double
    let ozone: Double
}

struct DailyWeather: Codable {
    let summary: String
    let icon: String
    let data: [DailyWeatherEntry]
}
struct DailyWeatherEntry: Codable {
    let time: Int
    let summary: String
    let icon: String
    let sunriseTime: Int
    let sunsetTime: Int
    let moonPhase: Double
    let precipIntensity: Float
    let precipIntensityMax: Float
    //let precipIntensityMaxTime: Int
    let precipProbability: Double
    let precipType: String?
    let temperatureHigh: Double
    let temperatureHighTime: Int
    let temperatureLow: Double
    let temperatureLowTime: Int
    let apparentTemperatureHigh: Double
    let apparentTemperatureHighTime: Int
    let apparentTemperatureLow: Double
    let apparentTemperatureLowTime: Int
    let dewPoint: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windGust: Double
    let windGustTime: Int
    let windBearing: Int
    let cloudCover: Double
    let uvIndex: Int
    let uvIndexTime: Int
    let visibility: Double
    let ozone: Double
    let temperatureMin: Double
    let temperatureMinTime: Int
    let temperatureMax: Double
    let temperatureMaxTime: Int
    let apparentTemperatureMin: Double
    let apparentTemperatureMinTime: Int
    let apparentTemperatureMax: Double
    let apparentTemperatureMaxTime: Int
    
}
struct HourlyWeather: Codable {
    let summary: String
    let icon: String
    let data: [HourlyWeatherEntry]
}

struct HourlyWeatherEntry: Codable {
    let time: Int
    let summary: String
    let icon: String
    let precipIntensity: Float
    let precipProbability: Double
    let precipType: String?
    let temperature: Double
    let apparentTemperature: Double
    let dewPoint: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windGust: Double
    let windBearing: Int
    let cloudCover: Double
    let uvIndex: Int
    let visibility: Double
    let ozone: Double
}
