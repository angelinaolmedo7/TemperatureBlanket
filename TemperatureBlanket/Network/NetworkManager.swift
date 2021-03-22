
import Foundation

class NetworkManager {
    // shared singleton session object used to run tasks
    let urlSession = URLSession.shared

    var token = ""  // shouldn't need this
    
    // made generic in getAPIresponse()
//    func getAvgWeather(zip: String="94108", _ completion: @escaping (Result<WeatherAvgsResponse>) -> Void) {
//        let postsRequest = makeRequest(zip: zip, for: .historicalAvgs)
//
//        let task = urlSession.dataTask(with: postsRequest) { data, response, error in
//            // Check for errors.
//            if let error = error {
//                return completion(Result.failure(error))
//            }
//
//            // Check to see if there is any data that was retrieved.
//            guard let data = data else {
//                return completion(Result.failure(EndPointError.noData))
//            }
//
//            // Attempt to decode the data.
//            guard let result = try? JSONDecoder().decode(WeatherAvgsResponse.self, from: data) else {
//                return completion(Result.failure(EndPointError.couldNotParse))
//            }
//
//            // Return the result with the completion handler.
//            DispatchQueue.main.async {
//                completion(Result.success(result))
//            }
//        }
//        task.resume()
//    }
    
    func getAPIresponse(query: [String], endpoint: EndPoints, _ completion: @escaping (Result<Any>) -> Void) {
        let postsRequest = makeRequest(query: query, for: endpoint)
        
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
            let result: Any?
            switch endpoint {
            case .weather:
                guard let res = try? JSONDecoder().decode(WeatherResponse.self, from: data) else {
                    return completion(Result.failure(EndPointError.couldNotParse))
                }
                result = res
            case .historicalAvgs:
                guard let res = try? JSONDecoder().decode(WeatherAvgsResponse.self, from: data) else {
                    return completion(Result.failure(EndPointError.couldNotParse))
                }
                result = res
            case .latlong:
                guard let res = try? JSONDecoder().decode(LatLongResponse.self, from: data) else {
                    return completion(Result.failure(EndPointError.couldNotParse))
                }
                result = res
            }
        
            // Return the result with the completion handler.
            DispatchQueue.main.async {
                completion(Result.success(result!))
            }
        }
        task.resume()
    }
    
    enum EndPoints {
        case weather
        case historicalAvgs
        case latlong
        
        func getBaseURL() -> String {
            switch self {
            case .weather:
                return "https://api.openweathermap.org/data/2.5/"
            case .historicalAvgs:
                return "https://api.worldweatheronline.com/premium/v1/"
            case .latlong:
                return "https://public.opendatasoft.com/api/records/1.0/"
            }
        }
        
        func getPath() -> String {
            switch self {
            case .weather:
                return "weather"
            case .historicalAvgs:
                return "weather.ashx"
            case .latlong:
                return "search"
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
        
        func getParams(_ query: [String]) -> [String: String] {
            switch self {
            case .weather:
                return [
                    "zip": query[0],
                    "appid": "25923e26c318157537e1fa24b59a7ae8",
                ]
            case .historicalAvgs:
                return [
                    "key": config["WWO_KEY"]!,
                    "q": query[0],
                    "fx": "no",
                    "cc": "no",
                    "mca": "yes",
                    "format": "json",
                    
                ]
            case .latlong:
                return [
                    "dataset": "us-zip-code-latitude-and-longitude",
                    "q": query[0],
                ]
            }
        }
        
        func paramsToString(_ query: [String]) -> String {
            let parameterArray = getParams(query).map { key, value in
                return "\(key)=\(value)"
            }

            return parameterArray.joined(separator: "&")
        }
    }
    
    private func makeRequest(query: [String], for endPoint: EndPoints) -> URLRequest {
        // get the base URL for the API
        let baseURL = endPoint.getBaseURL()
        // grab the parameters from the endpoint and convert them into a string
        let stringParams = endPoint.paramsToString(query)
        // get the path of the endpoint
        let path = endPoint.getPath()
        // create the full url from the above variables
        let fullURL = URL(string: baseURL.appending("\(path)?\(stringParams)"))!
        // build the request
        print(fullURL)
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
