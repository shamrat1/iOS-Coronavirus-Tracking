//
//  SingleCountry.swift
//  Coronavirus Tracking
//
//  Created by Yasin Shamrat on 28/5/20.
//  Copyright © 2020 Yasin Shamrat. All rights reserved.
//

import Foundation


struct SingleCountry:Codable {
    var country: String?
    var countryCode: String?
    var province:String?
    var city:String?
    var cityCode:String?
    var lat:String?
    var lon:String?
    var confirmed:Int?
    var deaths:Int?
    var recovered:Int?
    var active:Int?
    var date:String?
    
    private enum CodingKeys: String,CodingKey {
        case country = "Country"
        case countryCode = "CountryCode"
        case province = "Province"
        case city = "City"
        case cityCode = "CityCode"
        case lat = "Lat"
        case lon = "Lon"
        case confirmed = "Confirmed"
        case deaths = "Deaths"
        case recovered = "Recovered"
        case active = "Active"
        case date = "Date"
    }
    
}
