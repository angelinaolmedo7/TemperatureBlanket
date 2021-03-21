//
//  WeatherBracket.swift
//  TemperatureBlanket
//
//  Created by Angelina Olmedo on 3/18/21.
//

import Foundation

struct WeatherBracket: Codable {
    var weatherYearlyAvgs: WeatherYearlyAvgs
    
    static func suggestBrackets(colors: [String], avgs: WeatherYearlyAvgs) {
        let range = avgs.absMax - avgs.absMin
        
        
    }
    
}

struct WeatherYearlyAvgs: Codable {
    var mins: [Int]
    var maxes: [Int]
    var absMin: Int
    var absMax: Int
    
    init(APIresponse: WeatherAvgsResponse) {
        self.mins = []
        self.maxes = []
        
        for month in APIresponse.main.climateAverages[0].month {
            if let min = Int(month.avgMinTemp_F) {
                self.mins.append(min)
            }
            if let max = Int(month.absMaxTemp_F) {
                self.mins.append(max)
            }
        }
        
        self.absMin = mins.min() ?? 0
        self.absMax = maxes.max() ?? 0
    }
    
}
