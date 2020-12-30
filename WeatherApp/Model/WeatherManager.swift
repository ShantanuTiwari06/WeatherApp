//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Shantanu on 30/12/20.
//
import Foundation

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=d26bef715c4ac13b498a2a60c06fb5c5&units=metric"
    
//    MARK:- Fetch Weather
    func fetchWeather(cityName: String) {
//cityName <- city <- searchTextField.text .
        let urlString = "\(weatherURL)&q=\(cityName)"
//        print(urlString)
        performRequest(urlString: urlString)
    }
    
    //    MARK:- Perform Request
    func performRequest(urlString : String) {
// 1. Create URL
        if let url = URL(string: urlString) {
// 2. Create a URL Session
            let session = URLSession(configuration: .default)
// 3. Give URL Session a task
            
//let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
            
//            MARK:- Handle Fn as a Closure
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
//                        let weatherVC = WeatherViewController()
//                        weatherVC.didUpdateWeather(weather: weather)
//                        delegate?.didUpdateWeather(weather: weather)
                    }
                }
            }
// 4. Start the task
            task.resume()
        }
    }
    
//    MARK:- ParseJSON
    func parseJSON(weatherData: Data) -> WeatherModel?  {
// JSONDecoder is an object that can decode JSON we r going to just initialize it
        let decoder = JSONDecoder()
        do {
// WeatherData.self -> indicates Type
// weatherData -> indicates Object
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
//           
            print(decodedData.main.temp)
            print(decodedData.weather[0].description)
            print(decodedData.weather[0].id)
            
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
          
            // weather - obj. from WeatherModel
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather  // This is new line .
//            print(weather.conditionName)

        }catch{
            print(error)
            return nil
        }
    }
    

// Closure Fn . -
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
