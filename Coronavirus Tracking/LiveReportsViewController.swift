//
//  LiveReportsViewController.swift
//  Coronavirus Tracking
//
//  Created by Yasin Shamrat on 13/5/20.
//  Copyright © 2020 Yasin Shamrat. All rights reserved.
//

import UIKit

class LiveReportsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let url = URL(string: "https://api.covid19api.com/summary")!
    var countryData:Countries?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (responseData, response, error) in
            print("here")
            do{
                let decoded = try JSONDecoder().decode(Countries.self, from: responseData!)
                print(decoded)
            }catch let error {
                print(error.localizedDescription)
            }
            
        }.resume()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryData?.allCountries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportsCell") as! LiveReportsTableViewCell
        return cell
    }
    

}
//"Country": "ALA Aland Islands",
//"CountryCode": "AX",
//"Slug": "ala-aland-islands",
//"NewConfirmed": 0,
//"TotalConfirmed": 0,
//"NewDeaths": 0,
//"TotalDeaths": 0,
//"NewRecovered": 0,
//"TotalRecovered": 0,
//"Date": "2020-04-05T06:37:00Z"

struct Countries: Codable {
    var allCountries: [Country]?
    
    private enum CodingKeys: String, CodingKey {
        case allCountries = "Countries"
    }
    
}
struct Country:Codable {
    var country: String?
    var countryCode: String?
    var slug:String?
    var newConfirmed: Int?
    var totalConfirmed: Int?
    var newDeaths: Int?
    var totalDeaths: Int?
    var newRecovered: Int?
    var totalRecovered: Int?
    var date: String?
    
    private enum CodingKeys: String,CodingKey {
        case country = "Country"
        case countryCode = "CountryCode"
        case slug = "Slug"
        case newConfirmed = "NewConfirmed"
        case totalConfirmed = "TotalConfirmed"
        case newDeaths = "NewDeaths"
        case totalDeaths = "TotalDeaths"
        case newRecovered = "NewRecovered"
        case totalRecovered = "TotalRecovered"
        case date = "Date"
    }
}
