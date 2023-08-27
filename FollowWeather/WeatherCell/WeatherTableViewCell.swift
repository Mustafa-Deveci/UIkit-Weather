//
//  WeatherTableViewCell.swift
//  FollowWeather
//
//  Created by mustafa deveci on 26.08.2023.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifier = "WeatherTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherTableViewCell", bundle: nil)
    }
    
    func configure(with model: WeatherData.Main) {
        self.highTempLabel.textAlignment = .center
        self.lowTempLabel.textAlignment = .center
        
        let temperatureMinCelsius = model.temp_min - 273.15
        let temperatureMaxCelsius = model.temp_max - 273.15

        self.lowTempLabel.text = "\(Int(temperatureMinCelsius))°C"
        self.highTempLabel.text = "\(Int(temperatureMaxCelsius))°C"

        self.dayLabel.text = getDayforDate(Date(timeIntervalSince1970: Double(timezone)))
        self.iconImageView.image = UIImage(named: "Rainy")
        self.iconImageView.contentMode = .scaleAspectFit
   
    }
    
//    func configure2(with model1: WeatherData.Weather) {
//
//        let icon = model1
//
//        if model1.main.contains("Rain") {
//            self.iconImageView.image = UIImage(named: "Rainy")
//        }
//        else if model1.main.contains("Clouds") {
//            self.iconImageView.image = UIImage(named: "Cloud")
//        }else {
//            print("gg")
//        }
//
//
//    }

    
    func getDayforDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: inputDate)
        
    }
    
}
