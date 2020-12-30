//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Shantanu on 30/12/20.
//

import Foundation

// Decodable Protocol -> Weather Data turned into a type that can decode itself from an external representation namely the JSON representation

// Inplace of Decodable and Encodable just write Codable This is (typealias) means it combines two protocols in one .
//struct WeatherData : Decodable,Encodable { }

struct WeatherData : Codable {
    let name : String
    let main : Main
    let weather : [Weather]
}

// Object with prop.
struct Main: Codable {
    let temp : Double
}

// array
struct Weather : Codable {
    let description : String
    let id : Int
}
