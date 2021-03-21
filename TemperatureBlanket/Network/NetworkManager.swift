
import Foundation

class NetworkManager {
    // shared singleton session object used to run tasks. Will be useful later
    let urlSession = URLSession.shared

    var token = ""
    
    func getWeather(_ completion: @escaping (Result<WeatherResponse>) -> Void) {
       let postsRequest = makeRequest(for: .weather)
       let task = urlSession.dataTask(with: postsRequest) { data, response, error in
           // Check for errors.
           if let error = error {
               return completion(Result.failure(error))
           }

           // Check to see if there is any data that was retrieved.
           guard let data = data else {
               return completion(Result.failure(EndPointError.noData))
           }
                
           // Attempt to decode the data.
           guard let result = try? JSONDecoder().decode(WeatherResponse.self, from: data) else {
               return completion(Result.failure(EndPointError.couldNotParse))
           }
                        
           // Return the result with the completion handler.
           DispatchQueue.main.async {
               completion(Result.success(result))
           }
       }
       task.resume()
    }
    
    enum EndPoints {
        case weather
        
        func getBaseURL() -> String {
            switch self {
            case .weather:
                return "https://api.openweathermap.org/data/2.5/"
            }
        }
        
        func getPath() -> String {
            switch self {
            case .weather:
                return "weather"
            }
        }
        
        func getHTTPMethod() -> String {
            return "GET"
        }
        
        func getHeaders(token: String) -> [String: String] {
            return [
                "Accept": "application/json",
                "Content-Type": "application/json"
            ]
        }
        
        func getParams() -> [String: String] {
            switch self {
            case .weather:
                return [
                    "zip": "94108",  // TODO: REMOVE PLACEHOLDER
                    "appid": "25923e26c318157537e1fa24b59a7ae8"
                ]
            }
        }
        
        func paramsToString() -> String {
            let parameterArray = getParams().map { key, value in
                return "\(key)=\(value)"
            }

            return parameterArray.joined(separator: "&")
        }
    }
    
    private func makeRequest(for endPoint: EndPoints) -> URLRequest {
        // get the base URL for the API
        let baseURL = endPoint.getBaseURL()
        // grab the parameters from the endpoint and convert them into a string
        let stringParams = endPoint.paramsToString()
        // get the path of the endpoint
        let path = endPoint.getPath()
        // create the full url from the above variables
        let fullURL = URL(string: baseURL.appending("\(path)?\(stringParams)"))!
        // build the request
        var request = URLRequest(url: fullURL)
        request.httpMethod = endPoint.getHTTPMethod()
        request.allHTTPHeaderFields = endPoint.getHeaders(token: token)
                
        return request
    }
    
    enum Result<T> {
        case success(T)
        case failure(Error)
    }
    enum EndPointError: Error {
        case couldNotParse
        case noData
    }
}
