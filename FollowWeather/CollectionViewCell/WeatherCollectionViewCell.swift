//
//  WeatherCollectionViewCell.swift
//  FollowWeather
//
//  Created by mustafa deveci on 29.08.2023.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    static let identifier = "WeatherCollectionViewCell"

    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell",
                     bundle: nil)
    }

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!

    func configure(with model: WeatherData.Weather) {
        self.tempLabel.text = "\(model.main)"
        self.iconImageView.contentMode = .scaleAspectFit
        self.iconImageView.image = UIImage(named: "sun")

    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
