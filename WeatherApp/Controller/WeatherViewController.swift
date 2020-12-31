//
//  ViewController.swift
//  WeatherApp
//
//  Created by Shantanu on 30/12/20.
//

import UIKit
import CoreLocation     // for user current location .

//UITextFieldDelegate , WeatherManagerDelegate are protocols .
class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    // Model
    var weatherManager = WeatherManager()
    // For user current location .
    let locationManager = CLLocationManager()
//MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // This is V-Imp .
        locationManager.delegate = self
        // for current location
        // requestWhenInUseAuthorization -  This is explicit permission bcoz it is private for user .
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()    // to get the current location of user.
        // This is V-Imp .
//        locationManager.delegate = self // if this written after requestLocation() happens app crashes .
        // The text field should report back to our VC .
        // self refers to current VC or class .
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    // Reset Location Button Pressed .
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()    // to get the current location of user.
    }
    
}

//MARK:- UITextFieldDelegate
extension WeatherViewController : UITextFieldDelegate {
    
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
        //        pr int(searchTextField.text!)
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
}
//MARK:- WeatherManagerDelegate
extension WeatherViewController : WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel) {
        DispatchQueue.main.async {
            print(weather.temperature)
            print(weather.cityName)
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}
//MARK:- CLLocationManagerDelegate
extension WeatherViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("Got a Location Data")
//        locations.last is an optional so we have to optionally bind it .
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
//            print(lat)
//            print(lon)
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


