//
//  LatLong.swift
//  TemperatureBlanket
//
//  Created by Angelina Olmedo on 3/22/21.
//

import Foundation
struct LatLongResponse: Codable {
    let records: [Record]
    
    struct Record: Codable {
        let fields: Field
        
        struct Field: Codable {
            let city: String
            let zip: String
            let longitude: Double
            let state: String
            let latitude: Double
        }
    }
}
