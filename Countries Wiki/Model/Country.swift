//
//  Countries.swift
//  Countries wiki
//
//  Created by user246073 on 9/29/24.
//
import Foundation

struct Country: Decodable {
    let name: Name?
    let capital: [String]?
    let region: String?
    let subregion: String?
    let population: Int?
    let area: Double?
    let flags: Flags?
    let languages: [String: String]?
    let currencies: [String: Currency]?
    let timezones: [String]?
    let borders: [String]?
    
    init(name: Name?, capital: [String]?, region: String?, subregion: String?, population: Int?, area: Double?, flags: Flags?, languages: [String : String]?, currencies: [String : Currency]?, timezones: [String]?, borders: [String]?) {
        self.name = name
        self.capital = capital
        self.region = region
        self.subregion = subregion
        self.population = population
        self.area = area
        self.flags = flags
        self.languages = languages
        self.currencies = currencies
        self.timezones = timezones
        self.borders = borders
    }
    
    init(countryDetails: [String: Any]) {
        if let nameDict = countryDetails["name"] as? [String: Any] {
            self.name = Name(dict: nameDict)
        } else {
            self.name = nil
        }
        
        self.capital = countryDetails["capital"] as? [String]
        self.region = countryDetails["region"] as? String
        self.subregion = countryDetails["subregion"] as? String
        self.population = countryDetails["population"] as? Int
        self.area = countryDetails["area"] as? Double
        
        if let flagsDict = countryDetails["flags"] as? [String: Any] {
            self.flags = Flags(dict: flagsDict)
        } else {
            self.flags = nil
        }
        
        self.languages = countryDetails["languages"] as? [String: String]
        
        if let currenciesDict = countryDetails["currencies"] as? [String: Any] {
            var currencies = [String: Currency]()
            for (key, value) in currenciesDict {
                if let currencyDict = value as? [String: Any] {
                    currencies[key] = Currency(dict: currencyDict)
                }
            }
            self.currencies = currencies
        } else {
            self.currencies = nil
        }
        
        self.timezones = countryDetails["timezones"] as? [String]
        self.borders = countryDetails["borders"] as? [String]
    }
    
    static func getCountry(from value: Any) -> [Country] {
        guard let countryDetails = value as? [[String: Any]] else { return [] }
        return countryDetails.map { Country(countryDetails: $0) }
    }
}

struct Name: Decodable {
    let common: String?
    let official: String?
    let nativeName: [String: NativeName]?
    
    init(common: String?, official: String?, nativeName: [String : NativeName]?) {
        self.common = common
        self.official = official
        self.nativeName = nativeName
    }
    
    init(dict: [String: Any]) {
        self.common = dict["common"] as? String
        self.official = dict["official"] as? String
        
        if let nativeNameDict = dict["nativeName"] as? [String: Any] {
            var nativeNames = [String: NativeName]()
            for (key, value) in nativeNameDict {
                if let nativeNameValue = value as? [String: Any] {
                    nativeNames[key] = NativeName(dict: nativeNameValue)
                }
            }
            self.nativeName = nativeNames
        } else {
            self.nativeName = nil
        }
    }
}

struct NativeName: Decodable {
    let official: String?
    let common: String?
    
    init(official: String?, common: String?) {
        self.official = official
        self.common = common
    }
    
    init(dict: [String: Any]) {
        self.official = dict["official"] as? String
        self.common = dict["common"] as? String
    }
}

struct Flags: Decodable {
    let png: String?
    let svg: String?
    
    init(png: String?, svg: String?) {
        self.png = png
        self.svg = svg
    }
    
    init(dict: [String: Any]) {
        self.png = dict["png"] as? String
        self.svg = dict["svg"] as? String
    }
}

struct Currency: Decodable {
    let name: String?
    let symbol: String?
    
    init(name: String?, symbol: String?) {
        self.name = name
        self.symbol = symbol
    }
    
    init(dict: [String: Any]) {
        self.name = dict["name"] as? String
        self.symbol = dict["symbol"] as? String
    }
}
                         
    
    
   
