//
//  DetailsViewController.swift
//  Countries wiki
//
//  Created by user246073 on 9/29/24.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var imageFlag: UIImageView!
    private let networkManager = NetworkManager.shared
    
    var country: Country!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        imageFix()
        textlabelUpdate()
        setupGradientBackground()
        title = country.name?.common
    }
    
    // MARK: - Update UI Methods
    private func textlabelUpdate() {
        guard let country = country else { return }
        
        var descriptionText = ""
        
        if let commonName = country.name?.common {
            descriptionText += "Название: \(commonName)\n"
        }
        
        if let capital = country.capital?.joined(separator: ", ") {
            descriptionText += "Столица: \(capital)\n"
        }
        
        if let region = country.region {
            descriptionText += "Регион: \(region)\n"
        }
        
        if let population = country.population {
            let populationFormatted = NumberFormatter.localizedString(from: NSNumber(value: population), number: .decimal)
            descriptionText += "Население: \(populationFormatted)\n"
        }
        
        if let area = country.area {
            let areaFormatted = String(format: "%.2f", area)
            descriptionText += "Площадь: \(areaFormatted) км²\n"
        }
        
        if let languages = country.languages {
            let languagesList = languages.values.joined(separator: ", ")
            descriptionText += "Языки: \(languagesList)\n"
        }
        
        if let currencies = country.currencies {
            let currencyNames = currencies.values.compactMap { $0.name }.joined(separator: ", ")
            descriptionText += "Валюта: \(currencyNames)\n"
        }
        
        if let timezones = country.timezones?.joined(separator: ", ") {
            descriptionText += "Часовые пояса: \(timezones)\n"
        }
        
        if let borders = country.borders?.joined(separator: ", ") {
            descriptionText += "Граничит с: \(borders)\n"
        }
        
        descriptionLabel.text = descriptionText
    }
    
    // MARK: - UI Setup Methods
    private func imageFix() {
        imageFlag?.contentMode = .scaleAspectFill
        imageFlag?.layer.cornerRadius = 15
        imageFlag?.layer.masksToBounds = true  // Альтернатива clipsToBounds
        imageFlag?.layer.shouldRasterize = true
        imageFlag?.layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func updateUI() {
        networkManager.fetchData(from: country.flags?.png ?? "") { [unowned self] result in
            switch result {
            case .success(let imageData):
                imageFlag.image = UIImage(data: imageData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func textLine() {
        guard let labelText = descriptionLabel.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        descriptionLabel.attributedText = NSAttributedString(
            string: labelText,
            attributes: [.paragraphStyle: paragraphStyle]
        )
    }
    
    private func setupGradientBackground() {
            let gradientLayer = CAGradientLayer()
            
            gradientLayer.colors = [
                UIColor.green.cgColor,
                UIColor.white.cgColor,
                UIColor.blue.cgColor
            ]
            
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.frame = view.bounds
            view.layer.insertSublayer(gradientLayer, at: 0)
        }
}
 


