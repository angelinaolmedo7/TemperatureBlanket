import Foundation

struct WeatherResponse {
    let weather: [Weather?]
    let main: Main?
}

extension WeatherResponse: Decodable {
    // mess with this later if you care to
}

struct Weather {
    let main: String?
}

extension Weather: Decodable {
    // coding keys here if necessary
}

struct Main {
    let temp: Double?
    let humidity: Int?
    
    static func kelvinToF(kel: Double) -> Double {
        return ((kel - 273.15) * 9/5 + 32)
    }
}

extension Main: Decodable {
    // coding keys here if necessary
}
