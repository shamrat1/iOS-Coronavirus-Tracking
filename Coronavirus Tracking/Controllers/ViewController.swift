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
    var data = [SingleCountry]()
    @IBOutlet weak var lineChart: LineChartView!
    var activeValues = [ChartDataEntry]()
    var deathValues = [ChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupLine()
        // get current date
        let date = Date().string(format: "yy-MM-dd")
        print(date)
        
        let url = URL(string: "https://api.covid19api.com/country/bangladesh?from=2020-05-07T00:00:00Z&to=\(date)T00:00:00Z")!
        let request = URLRequest(url: url)
        let task = URLSession.shared
        task.dataTask(with: request) { (responseData, response, error) in
            guard let data = responseData else {
                return print("Error Fetching Data")
            }
            
            do {
                self.data = try JSONDecoder().decode([SingleCountry].self, from: data)
                print("success")
                
                for i in 0..<self.data.count{
                    let activeCases = self.data[i].active!
                    let deathCases = self.data[i].deaths!
                    
                    self.activeValues.append(ChartDataEntry(x: Double(i), y: Double(activeCases)))
                    self.deathValues.append(ChartDataEntry(x: Double(i), y: Double(deathCases)))
                }
                DispatchQueue.main.async {
                    self.updateUI()
                }
                
            }catch let err {
                print(err.localizedDescription)
            }
        }.resume()
    }
    func setupLine() {
        
        lineChart.backgroundColor = UIColor.blue
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.labelTextColor = .white
        
        lineChart.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        lineChart.leftAxis.labelTextColor = .white
        lineChart.leftAxis.labelFont = .boldSystemFont(ofSize: 12)
        lineChart.rightAxis.enabled = false
        
        lineChart.animate(xAxisDuration: 2.5)
    }
    
    func updateUI(){
        let set1 = LineChartDataSet(values: activeValues, label: "Active cases")
        let set2 = LineChartDataSet(values: deathValues, label: "Death")
        let data = LineChartData(dataSets: [set1,set2])
        lineChart.data = data
    }
    
    


}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

//"Country": "Bangladesh",
//"CountryCode": "BD",
//"Province": "",
//"City": "",
//"CityCode": "",
//"Lat": "23.68",
//"Lon": "90.36",
//"Confirmed": 3,
//"Deaths": 0,
//"Recovered": 0,
//"Active": 3,
//"Date": "2020-03-08T00:00:00Z"

struct SingleCountry:Codable {
    var country: String?
    var countryCode: String?
    var province:String?
    var city:String?
    var cityCode:String?
    var lat:String?
    var lon:String?
    var confirmed:Int?
    var deaths:Int?
    var recovered:Int?
    var active:Int?
    var date:String?
    
    private enum CodingKeys: String,CodingKey {
        case country = "Country"
        case countryCode = "CountryCode"
        case province = "Province"
        case city = "City"
        case cityCode = "CityCode"
        case lat = "Lat"
        case lon = "Lon"
        case confirmed = "Confirmed"
        case deaths = "Deaths"
        case recovered = "Recovered"
        case active = "Active"
        case date = "Date"
    }
    
}

