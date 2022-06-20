//
//  HourlyTableViewCell.swift
//  WeatherApp
//
//  Created by Mustafa Pekdemir on 22.03.2022.
//

import UIKit

class HourlyTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    

    @IBOutlet var collectionView: UICollectionView!
    var models = [HourlyWeatherEntry]()
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WeatherCollectionViewCell.nib(), forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifier = "HourlyTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "HourlyTableViewCell", bundle: nil)
    }
    func configure(with models: [HourlyWeatherEntry]) {
        self.models = models
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier, for: indexPath) as! WeatherCollectionViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }

}
