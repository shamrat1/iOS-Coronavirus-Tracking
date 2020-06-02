//
//  Countries.swift
//  Coronavirus Tracking
//
//  Created by Yasin Shamrat on 28/5/20.
//  Copyright © 2020 Yasin Shamrat. All rights reserved.
//

import Foundation

struct Countries: Codable {
    var allCountries: [Country]?
    
    private enum CodingKeys: String, CodingKey {
        case allCountries = "Countries"
    }
    
}
struct Country:Codable {
    var country: String?
    var countryCode: String?
    var slug:String?
    var newConfirmed: Int?
    var totalConfirmed: Int?
    var newDeaths: Int?
    var totalDeaths: Int?
    var newRecovered: Int?
    var totalRecovered: Int?
    var date: String?
    
    private enum CodingKeys: String,CodingKey {
        case country = "Country"
        case countryCode = "CountryCode"
        case slug = "Slug"
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
        case date = "Date"
    }
}


struct CountryWithLatLon: Codable {
    var name: String?
    var alpha2Code: String?
    var latlng:[String]?
}

