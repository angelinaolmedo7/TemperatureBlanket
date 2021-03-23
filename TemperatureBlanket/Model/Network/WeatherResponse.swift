import Foundation

struct WeatherResponse: Codable {
    let weather: [Weather?]
    let main: Main?
    
    struct Weather: Codable {
        let main: String?
    }
    
    struct Main: Codable {
        let temp: Double?
    }
    
    static func kelvinToF(kel: Double) -> Double {
        return ((kel - 273.15) * 9/5 + 32)
    }
}
