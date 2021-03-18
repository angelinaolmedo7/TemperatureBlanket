//
//  LogItem.swift
//  NobHillWeather
//
//  Created by Angelina Olmedo on 6/11/20.
//  Copyright © 2020 Angelina Olmedo. All rights reserved.
//

import Foundation
import os.log

class LogItem: Codable {
    
    let mood: String?
    let date: String!
    let weatherString: String!
    
    public var description: String {
        return "LogItem: \(String(describing: mood)), \(String(describing: date)), \(String(describing: weatherString))"
    }
    
    private enum CodingKeys: String, CodingKey {
        case mood
        case date
        case weatherString
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("logs")
    
    init(mood: String?, weather: WeatherResponse) {
        self.mood = mood
        self.date = NSDate.now.description(with: Locale(identifier: "en_US"))
        
        let fTemp = Double(round(100*(Main.kelvinToF(kel: (weather.main?.temp)!)))/100) // round to 2 decimal places
        let desc = weather.weather[0]?.main
        self.weatherString = "\(fTemp)°F, \(desc ?? "ERROR")"
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(mood, forKey: .mood)
      try container.encode(date, forKey: .date)
      try container.encode(weatherString, forKey: .weatherString)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.mood = try container.decode(String.self, forKey: .mood)
        self.date = try container.decode(String.self, forKey: .date)
        self.weatherString = try container.decode(String.self, forKey: .weatherString)
    }
    
    
//    init(mood: String?, date: NSDate, weatherString: String) {
//        self.mood = mood
//        self.date = date
//        self.weatherString = weatherString
//
//        super.init()
//    }

}
