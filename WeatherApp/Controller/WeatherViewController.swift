//
//  ViewController.swift
//  Weather App
//
//  Created by Shantanu Tiwari on 22/12/2020.
//  Copyright © 2020 Shantanu Tiwari. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    // Model
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
// The text field should report back to our VC .
// self refers to current VC or class .
        searchTextField.delegate = self
    }

    @IBAction func searchPressed(_ sender: UIButton) {
// this tells the searchfield, we're done with editing & u can dismiss the keyboard .
        searchTextField.endEditing(true)
//        print(searchTextField.text!)
    }
    
// this will ask the delegate which is the current class .
// if the text field should process the pressing of the return btn.
    
    // hey VC, the usr prsd return key in keyboard .
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    // dismiss the keyboard .
        searchTextField.endEditing(true)
//        print(searchTextField.text!)
        return true
    }
    
// useful for doing some validation on what user typed ?
// when return false then board will not dismiss in case of true board will dismss .
// call by text field when it detects the user dismissing the keyboard & this is the moment it's gonna pass in a reference to the textField that triggered this method.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else{
            textField.placeholder = "Type Something!"
// if false then it keeps the keyboard where it is & we're not gonna trigger textFieldDidEndEditing() method .
            return false
        }
    }
     
    // delegate method to reset or clear the text field to empty .
    func textFieldDidEndEditing(_ textField: UITextField) {
//  Use searchTextField.text to get the weather for that city .
       
        // here text is optional-String prop So, we have to unwrap this.
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
    func didUpdateWeather(weather: WeatherModel) {
        print(weather.temperature)
    }
}



