//
//  Location.swift
//  TemperatureBlanket
//
//  Created by Angelina Olmedo on 3/22/21.
//

import Foundation
struct Location: Codable {
    var zip: String
    var city: String
    var state: String
    var long: Double
    var lat: Double
    
    var description: String {
        return "\(city), \(state) \(zip) (\(lat), \(long))"
    }
    
    func darkSkysCall(date: Date) -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return ["\(lat)", "\(long)", formatter.string(from: date)]
    }
    
    init(zip: String, city: String, state: String, long: Double, lat: Double) {
        self.zip = zip
        self.city = city
        self.state = state
        self.long = long
        self.lat = lat
    }
    
    init(APIresponse: LatLongResponse) {
        self.init(zip: APIresponse.records[0].fields.zip,
                  city: APIresponse.records[0].fields.city,
                  state: APIresponse.records[0].fields.state,
                  long: APIresponse.records[0].fields.longitude,
                  lat: APIresponse.records[0].fields.latitude)
    }
}
