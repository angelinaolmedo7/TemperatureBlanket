//
//  WeatherBracket.swift
//  TemperatureBlanket
//
//  Created by Angelina Olmedo on 3/18/21.
//

import Foundation
import UIKit

struct WeatherBracket: Codable {
    var weatherYearlyAvgs: WeatherYearlyAvgs
    var colorBrackets: [ColorRange]
    
    init(APIresponse: WeatherAvgsResponse, colors: ColorPalette=ColorPresets.empty) {
        let yearlyAvgs = WeatherYearlyAvgs(APIresponse: APIresponse)
        self.init(weatherYearlyAvgs: yearlyAvgs, colors: colors)
    }
    
    init(weatherYearlyAvgs: WeatherYearlyAvgs, colors: ColorPalette=ColorPresets.empty) {
        self.weatherYearlyAvgs = weatherYearlyAvgs
        self.colorBrackets = WeatherBracket.suggestBrackets(colors: colors.colors, avgs: self.weatherYearlyAvgs)
    }
    
    static func APItoBrackets(APIresponse: WeatherAvgsResponse, colors: ColorPalette=ColorPresets.empty) -> [ColorRange] {
        let processedAvgs = WeatherYearlyAvgs(APIresponse: APIresponse)
        return self.suggestBrackets(colors: colors.colors, avgs: processedAvgs)
    }
    
    static func suggestBrackets(colors: [String], avgs: WeatherYearlyAvgs) -> [ColorRange] {
        // find the total range of temperatures
        let range = avgs.absMax - avgs.absMin
        
        // divide by the number of colors. not worried about differences in brackets caused by rounding
        let fraction: Int = (range/colors.count)
        
        // set up an array of ColorRange()
        var colorArray: [ColorRange] = []
        
        var lowTemp = avgs.absMin
        for color in colors {
            let highTemp = lowTemp + fraction
            colorArray.append(ColorRange(hex: color, minTemp: lowTemp, maxTemp: highTemp))
            lowTemp = highTemp
        }
        
        // the first color range should just be < and the last should be >
        colorArray[0].minTemp = nil
        colorArray[colorArray.endIndex-1].maxTemp = nil
        
        // debug print statement:
        print("From min temp \(avgs.absMin) and max temp \(avgs.absMax) the following brackets were generated:")
        print("\(colorArray)")
        
        return colorArray
    }
    
}

struct ColorRange: Codable {
    var hex: String
    var minTemp: Int?
    var maxTemp: Int?
        
    init(hex: String="FFFFFF", minTemp: Int?, maxTemp: Int?) {
        self.hex = hex
        self.minTemp = minTemp
        self.maxTemp = maxTemp
    }
    
    func isInRange(num: Int) -> Bool {
        return (minTemp ?? -100 < num) && (num < maxTemp ?? 200)
    }
}

struct ColorPalette: Codable {
    var name: String?
    var colors: [String]
    
    init(colors: [String], name: String?) {
        self.colors = colors
        self.name = name  // default palettes have names, custom ones don't
    }
    
    func getUIColors() -> [UIColor] {
        return colors.map { UIColor(hex: $0)! }
    }
}

// MARK: Preset color palettes
struct ColorPresets {
    static let empty = ColorPalette(colors: ["FFFFFF", "FFFFFF", "FFFFFF", "FFFFFF", "FFFFFF", "FFFFFF", "FFFFFF"],
                                  name: "Empty")
    static let warmToCool = ColorPalette(colors: ["ED512A", "FA9062", "FFDD9E", "FAF3DD", "B8F2E6", "9BD1D9", "5C6989"],
                                  name: "Empty")
    static let transPride = ColorPalette(colors: ["F7B6CD", "FCD9DB", "FFEBE6", "FFFFFF", "D1E0EB", "B5CFE3", "84B4D7"],
                                  name: "Trans Pride")
    static let easter = ColorPalette(colors: ["37E6E3", "90F1EF", "FFD6E0", "FFEF9F", "C1FBA4", "7BF1A8", "47EB86"],
                              name: "Easter")
    
    static let palettes = [warmToCool, transPride, easter]
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
            print("Month: \(month)")
            if let min = Float(month.avgMinTemp_F) {
                self.mins.append(Int(min))
            }
            if let max = Float(month.absMaxTemp_F) {
                self.maxes.append(Int(max))
            }
        }
        
        self.absMin = mins.min() ?? 0
        self.absMax = maxes.max() ?? 0
    }
    
}
