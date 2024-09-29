//
//  TableCell.swift
//  Countries wiki
//
//  Created by user246073 on 9/29/24.
//

import Foundation
import UIKit

final class TableCell: UITableViewCell {
    
    @IBOutlet var flagImage: UIImageView!
    @IBOutlet var nameCountryLabel: UILabel!
    @IBOutlet var capitalCountryLabel: UILabel!
    @IBOutlet var regionCountryLabel: UILabel!
    
    private let networkManager = NetworkManager.shared
    
    func configure(with country: Country) {
        nameCountryLabel.text = country.name?.common
        capitalCountryLabel.text = "The capital: \(country.capital?.first ?? "Unknown capital")"
        regionCountryLabel.text = "Region: \(country.region ?? "Unknown region")"
        
        networkManager.fetchData(from: country.flags?.png ?? "") { [unowned self] result in
            switch result {
            case .success(let imageData):
                flagImage.image = UIImage(data: imageData)
            case .failure(let error):
                print(error)
            }
        }
    }
}

