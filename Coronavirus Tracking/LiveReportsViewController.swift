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
import Toast_Swift

class LiveReportsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let loader = NVActivityIndicatorView(frame: .zero, type: .ballRotateChase, color: .red, padding: 0)
    let url = URL(string: "https://api.covid19api.com/summary")!
    var countryData:Countries?
    var filteredCountries: Countries?
    var searching = false
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countrySearchBar: UISearchBar!
    
    let refreshControl : UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(LiveReportsViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        countrySearchBar.delegate = self
        getData()
        self.tableView.addSubview(self.refreshControl)
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
                    DispatchQueue.main.async {
                        self.refreshControl.endRefreshing()
                        self.loader.stopAnimating()
                        self.view.makeToast("Error Fetching Data. Pull to try again.", duration: 2.0)
                    }
                    return
                }
                do{
                    let decoded = try JSONDecoder().decode(Countries.self, from: responseData!)
                    self.countryData = decoded
                    DispatchQueue.main.async {
                        self.view.makeToast("Success, Fetched \(self.countryData?.allCountries?.count ?? 0) results.", duration: 2.0)
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                        self.loader.stopAnimating()
                    }
                }catch let error {
                    print(error.localizedDescription)
                }

                }.resume()
        }
        
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl){
        getData()
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

extension LiveReportsViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("here")
        guard let allCountry = countryData?.allCountries else {
            return print("returning")
        }
//        allCountry.filter{ $0.country?.contains(searchText) }
        filteredCountries?.allCountries = allCountry.filter({ return $0.country!.contains(searchText)})
        print(filteredCountries?.allCountries)
    }
}

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
