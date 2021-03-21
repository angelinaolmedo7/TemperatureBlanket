import Foundation
import os.log

class LogItem: Codable {
    
    let date: String!
    let weatherString: String!
    
    public var description: String {
        return "LogItem: \(String(describing: date)), \(String(describing: weatherString))"
    }
    
    private enum CodingKeys: String, CodingKey {
        case date
        case weatherString
    }
    
    //MARK: Archiving Paths
//    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
//    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("logs")
    
    init(weather: WeatherResponse) {
        self.date = NSDate.now.description(with: Locale(identifier: "en_US"))
        
        let fTemp = Double(round(100*(Main.kelvinToF(kel: (weather.main?.temp)!)))/100) // round to 2 decimal places
        let desc = weather.weather[0]?.main
        self.weatherString = "\(fTemp)°F, \(desc ?? "ERROR")"
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(date, forKey: .date)
      try container.encode(weatherString, forKey: .weatherString)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(String.self, forKey: .date)
        self.weatherString = try container.decode(String.self, forKey: .weatherString)
    }
    
    // WRITE LOGS
    
//    static func saveLogs(logs: [LogItem]) {
//        let encoder = JSONEncoder()
//        if let encoded = try? encoder.encode(logs) {
//            do {
//                try encoded.write(to: URL(fileURLWithPath: LogItem.ArchiveURL.path))
//            }
//            catch {
//                print("Could not save to file.")
//            }
//        }
//    }
//
//    static func retrieveLogs() -> [LogItem]? {
//        do {
//            let savedData = try Data.init(contentsOf: URL(fileURLWithPath: LogItem.ArchiveURL.path))
//            let decoder = JSONDecoder()
//            if let decoded = try? decoder.decode([LogItem].self, from: savedData) {
//                return decoded
//            }
//        }
//        catch {
//            print("Could not retrieve data from file.")
//        }
//        return nil
//    }
//
//    static func clearLogs() {
//        let logs: [LogItem] = []
//        saveLogs(logs: logs)
//    }

}
