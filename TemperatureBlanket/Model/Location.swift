//
//  Location.swift
//  TemperatureBlanket
//
//  Created by Angelina Olmedo on 3/22/21.
//

import Foundation
struct Location: Decodable {
    var zip: String
    var city: String
    var state: String
    var lon: Float
    var lat: Float
    
    init(zip: String, city: String, state: String, lon: Float, lat: Float) {
        self.zip = zip
        self.city = city
        self.state = state
        self.lon = lon
        self.lat = lat
    }
}
