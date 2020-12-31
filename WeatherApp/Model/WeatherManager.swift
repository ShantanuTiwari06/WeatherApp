//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Shantanu on 30/12/20.
//
import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel)
    func didFailWithError(error: Error) // errorHandling
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=d26bef715c4ac13b498a2a60c06fb5c5&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
//    MARK:- FetchWeather()
    func fetchWeather(cityName: String) {
//cityName <- city <- searchTextField.text .
        let urlString = "\(weatherURL)&q=\(cityName)"
//        print(urlString)
        performRequest(with: urlString)
    }
    //    MARK:- FetchWeather()
    // for corelocation 
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    //    MARK:- PerformRequest()
//  func performRequest(urlString : String)
    func performRequest(with urlString : String) {
// 1. Create URL
        if let url = URL(string: urlString) {
// 2. Create a URL Session
            let session = URLSession(configuration: .default)
// 3. Give URL Session a task
            
//let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            
//            MARK:- Handle() as a Closure
//            MARK:- Completion Handler
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!) // errorHandling
//                    print(error!)
                    return
                }
                if let safeData = data {
//                                   self.parseJSON(weatherData: safeData)
                    if let weather = self.parseJSON(safeData) {
//                        let weatherVC = WeatherViewController()
//                        weatherVC.didUpdateWeather(weather: weather)
                        delegate?.didUpdateWeather(self, weather: weather)
                        // In above : self = WeatherManager
//                        self.delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
// 4. Start the task
            task.resume()
        }
    }
    
//    MARK:- ParseJSON()
    func parseJSON(_ weatherData: Data) -> WeatherModel?  {
// JSONDecoder is an object that can decode JSON we r going to just initialize it
        let decoder = JSONDecoder()
        do {
// WeatherData.self -> indicates Type
// weatherData -> indicates Object
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
          
//            print(decodedData.main.temp)
//            print(decodedData.weather[0].description)
//            print(decodedData.weather[0].id)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
          
            // weather - obj. from WeatherModel
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather  // This is new line .
//            print(weather.conditionName)

        }catch{
//            print(error)
            delegate?.didFailWithError(error: error)  // errorHandling
            return nil
        }
    }
    //MARK:- Handle() as Closure .
//    func handle(data: Data?, response: URLResponse?, error: Error?) {
//        if error != nil {
//            print(error!)
//            return
//        }
//
//        if let safeData = data {
//            let dataString = String(data: safeData, encoding: .utf8)
//            print(dataString)
//        }
//    }
}
