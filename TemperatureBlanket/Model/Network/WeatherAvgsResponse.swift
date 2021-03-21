//
//  WeatherAvgsResponse.swift
//  TemperatureBlanket
//
//  Created by Angelina Olmedo on 3/21/21.
//

import Foundation

struct WeatherAvgsResponse: Codable {
    let main: Main
    
    struct Main: Codable {
        let climateAverages: [ClimateAverages]
        
        struct ClimateAverages: Codable {
            let month: [Month]
            
            struct Month: Codable {
                let name: String
                let avgMinTemp_F: String
                let absMaxTemp_F: String
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case climateAverages = "ClimateAverages"
        }
        
    }
    
    enum CodingKeys: String, CodingKey {
        case main = "data"
    }
}
