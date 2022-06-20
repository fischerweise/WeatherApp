//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by Mustafa Pekdemir on 23.03.2022.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    static let identifier = "WeatherCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    func configure(with model: HourlyWeatherEntry) {
        self.tempLabel.text = "\(model.temperature)"
        self.iconImageView.contentMode = .scaleAspectFit
        self.iconImageView.image = UIImage(named: "sun")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

}
