//
//  LiveReportsViewController.swift
//  Coronavirus Tracking
//
//  Created by Yasin Shamrat on 13/5/20.
//  Copyright © 2020 Yasin Shamrat. All rights reserved.
//

import UIKit
import Kingfisher
import NVActivityIndicatorView

class LiveReportsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let loader = NVActivityIndicatorView(frame: .zero, type: .ballRotateChase, color: .red, padding: 0)
    let url = URL(string: "https://api.covid19api.com/summary")!
    var countryData:Countries?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getData()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryData?.allCountries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportsCell") as! LiveReportsTableViewCell
        guard let country = countryData?.allCountries?[indexPath.row], let totalConfirmed = country.totalConfirmed else {
            fatalError("country not found")
        }
        let countryCode = country.countryCode?.lowercased()
        let flagUrl = URL(string: "https://www.countryflags.io/\(countryCode!)/flat/64.png")!
        print(flagUrl)
        cell.currentTollLabel.text = String(totalConfirmed)
        cell.countryNameLabel.text = country.country
        cell.countryFlagImageView.kf.setImage(with: flagUrl)
        
        return cell
    }
    func getData(){
        loaderAnimate()
        
        let request = URLRequest(url: url)
        DispatchQueue.global(qos: .userInteractive).async {
            URLSession.shared.dataTask(with: request) { (responseData, response, error) in
                guard let response = response as? HTTPURLResponse, response.statusCode == 200, error == nil else {
                    fatalError("Problem fetching data")
                }
                do{
                    let decoded = try JSONDecoder().decode(Countries.self, from: responseData!)
                    self.countryData = decoded
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.loader.stopAnimating()
                    }
                }catch let error {
                    print(error.localizedDescription)
                }

                }.resume()
        }
        
    }
    
    func loaderAnimate() {
        loader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loader)
        
        NSLayoutConstraint.activate([
            loader.widthAnchor.constraint(equalToConstant: 40),
            loader.heightAnchor.constraint(equalToConstant: 40),
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        
        loader.startAnimating()
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
