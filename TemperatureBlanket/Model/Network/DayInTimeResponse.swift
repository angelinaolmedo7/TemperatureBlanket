//
//  DayInTimeResponse.swift
//  TemperatureBlanket
//
//  Created by Angelina Olmedo on 3/22/21.
//

import Foundation
struct DayInTimeResponse: Codable {
    let hourly: Hourly
    
    struct Hourly: Codable {
        let hours: [Hour]
        
        struct Hour: Codable {
            let temperature: Double
        }
        
        enum CodingKeys: String, CodingKey {
            case hours = "data"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case hourly = "hourly"
    }
}
