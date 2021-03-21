//
//  RecordedDay.swift
//  TemperatureBlanket
//
//  Created by Angelina Olmedo on 3/18/21.
//

import Foundation

class Blanket: Codable {
    
    var logs: [LogItem]
    var colors: WeatherBracket?
    
    private enum CodingKeys: String, CodingKey {
        case logs
        case colors
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("blanketArchives")
    
    init(logs: [LogItem]=[], colors: WeatherBracket?) {
        self.logs = logs
        self.colors = colors
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(logs, forKey: .logs)
      try container.encode(colors, forKey: .colors)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.logs = try container.decode([LogItem].self, forKey: .logs)
        self.colors = try container.decode(WeatherBracket?.self, forKey: .colors)
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
