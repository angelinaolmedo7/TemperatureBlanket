//
//  RecordedDay.swift
//  TemperatureBlanket
//
//  Created by Angelina Olmedo on 3/18/21.
//

import Foundation

class Blanket: Codable {
    
    var zipcode: String
    var logs: Year
    var colors: WeatherBracket?
    var location: Location?
    
    private enum CodingKeys: String, CodingKey {
        case zipcode
        case logs
        case colors
        case location
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("blanketArchives")
    
    init(zip: String, logs: Year?, colors: WeatherBracket?, location: Location?) {
        self.zipcode = zip
        self.logs = logs ?? Year()
        self.colors = colors
        self.location = location
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(zipcode, forKey: .zipcode)
        try container.encode(logs, forKey: .logs)
        try container.encode(colors, forKey: .colors)
        try container.encode(location, forKey: .location)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.zipcode = try container.decode(String.self, forKey: .zipcode)
        self.logs = try container.decode(Year.self, forKey: .logs)
        self.colors = try container.decode(WeatherBracket?.self, forKey: .colors)
        self.location = try container.decode(Location?.self, forKey: .location)
    }
    
    // WRITE LOGS
    static func saveBlanket(blanket: Blanket?) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(blanket) {
            do {
                try encoded.write(to: URL(fileURLWithPath: Blanket.ArchiveURL.path))
            }
            catch {
                print("Could not save to file.")
            }
        }
    }

    static func retrieveBlanket() -> Blanket? {
        do {
            let savedData = try Data.init(contentsOf: URL(fileURLWithPath: Blanket.ArchiveURL.path))
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(Blanket.self, from: savedData) {
                return decoded
            }
        }
        catch {
            print("Could not retrieve data from file.")
        }
        return nil
    }

    static func clearBlanket() {
        let blanket: Blanket? = nil
        saveBlanket(blanket: blanket)
    }
    
    
}

