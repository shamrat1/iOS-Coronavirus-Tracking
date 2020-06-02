//
//  ViewController.swift
//  Coronavirus Tracking
//
//  Created by Yasin Shamrat on 13/5/20.
//  Copyright © 2020 Yasin Shamrat. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {
    let countryWithLatLonURL = URL(string: "https://restcountries.eu/rest/v2/all")!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let request = URLRequest(url: countryWithLatLonURL)
        URLSession.shared.dataTask(with: request) { (responseData, response, error) in
            guard let response = response as? HTTPURLResponse, response.statusCode == 200, error == nil else {
                return
            }
            do{
                let data = try JSONDecoder().decode([CountryWithLatLon].self, from: responseData!)
                print(data)
            }catch let err {
                print(err.localizedDescription)
            }
            }.resume()
    }



}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}



