//
//  SingleReportViewController.swift
//  Coronavirus Tracking
//
//  Created by Yasin Shamrat on 26/5/20.
//  Copyright © 2020 Yasin Shamrat. All rights reserved.
//

import UIKit
import Charts
import Toast_Swift
import NVActivityIndicatorView

class SingleReportViewController: UIViewController {
    let loader = NVActivityIndicatorView(frame: .zero, type: .ballRotateChase, color: .red, padding: 0)
    var country : Country?
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var lineChart: LineChartView!
    
    let date = Date().string(format: "yy-MM-dd")
    let dateBefore = Calendar.current.date(byAdding: .day, value: -90, to: Date())?.string(format: "yy-MM-dd")
    let fromDate = Calendar.current.date(byAdding: .day, value: -60, to: Date())?.string(format: "yyyy-MM-dd")
    var data = [SingleCountry]()
    
    var activeValues = [ChartDataEntry]()
    var deathValues = [ChartDataEntry]()
    var recoveredValues = [ChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        getData()
    }
    
    func getData(){
        guard let countryName = country?.slug else {
            print("country not found")
            return
        }
        let url = URL(string: "https://api.covid19api.com/country/\(countryName)?from=\(dateBefore!)T00:00:00Z&to=\(date)T00:00:00Z")!
//        let url = URL(string: "https://api.covid19api.com/live/country/\(countryName)/status/confirmed/date/\(fromDate!)T00:00:00Z")! // to get all the results after the given date
        print(url)
        let request = URLRequest(url: url)
        let task = URLSession.shared
        loaderAnimate()
        task.dataTask(with: request) { (responseData, response, error) in
            guard let data = responseData else {
                print("Error Fetching Data")
                return
            }
            
            do {
                self.data = try JSONDecoder().decode([SingleCountry].self, from: data)
                print("success")
                
                for i in 0..<self.data.count{
                    guard let activeCases = self.data[i].active,
                        let deathCases = self.data[i].deaths,
                        let recoveredCases = self.data[i].recovered else {
                            return self.view.makeToast("Error, Data not available.",duration: 2.5)
                    }
                    
                    self.activeValues.append(ChartDataEntry(x: Double(i), y: Double(activeCases)))
                    self.deathValues.append(ChartDataEntry(x: Double(i), y: Double(deathCases)))
                    self.recoveredValues.append(ChartDataEntry(x: Double(i), y: Double(recoveredCases)))
                }
                DispatchQueue.main.async {
                    self.updateUI()
                    self.loader.stopAnimating()
                }
                
            }catch let err {
                print(err.localizedDescription)
            }
        }.resume()
    }
    
    @IBAction func onClickRefresh(_ sender: Any) {
        lineChart.data = nil
        pieChart.data = nil
        getData()
        
    }
    
    
    func setupUI() {
//        self.navigationController?.navigationBar.prefersLargeTitles =
        self.navigationItem.title = country?.country
        
        // Line Chart Setup
        lineChart.backgroundColor = UIColor(named: "paletteBackground")!
        lineChart.xAxis.labelPosition = .bottom
//        lineChart.xAxis.labelTextColor = .white
        lineChart.xAxis.labelFont = .boldSystemFont(ofSize: 12)
//        lineChart.leftAxis.labelTextColor = .white
        lineChart.leftAxis.labelFont = .boldSystemFont(ofSize: 12)
        lineChart.rightAxis.enabled = false
        lineChart.animate(xAxisDuration: 2.5)
        
        //pie Chart
        pieChart.animate(yAxisDuration: 2.5)
    }
    
    func updateUI(){
        
        // Line Chart
        let set1 = LineChartDataSet(values: activeValues, label: "Active cases")
        setupLineDataset(line: set1, color: "oceanicBlue", fillColor: "oceanicBlue", fillAlpha: 0.5)
        
        
        let set2 = LineChartDataSet(values: deathValues, label: "Death")
        setupLineDataset(line: set2, color: "paletteRed", fillColor: "paletteRed", fillAlpha: 0.5)
        
        let set3 = LineChartDataSet(values: recoveredValues, label: "Recovered")
        setupLineDataset(line: set3, color: "green", fillColor: "green", fillAlpha: 0.3)
        
        let data = LineChartData(dataSets: [set1,set2,set3])
        lineChart.data = data
        
        //Pie Chart
        guard  let totalConfirmed = country?.totalConfirmed,
            let totalDeaths = country?.totalDeaths,
            let totalRecovered = country?.totalRecovered
        else {
            print("pie data not available")
            return
        }
        
        let active = totalConfirmed - (totalDeaths + totalRecovered)
        let pieEntries = [
            PieChartDataEntry(value: Double(active), label: "Active Cases"),
            PieChartDataEntry(value: Double(totalDeaths), label: "Death Cases"),
            PieChartDataEntry(value: Double(totalRecovered), label: "Recovered Cases")
        ]
        let piedataSet = PieChartDataSet(values: pieEntries, label: nil)
        piedataSet.colors = [
            UIColor.blue,
            UIColor.red,
            UIColor.green,
            ]
        piedataSet.drawValuesEnabled = true
        
        let pieData = PieChartData(dataSet: piedataSet)
        pieChart.data = pieData
    }
    
    func setupLineDataset(line: LineChartDataSet,color: String,fillColor: String,fillAlpha: CGFloat){
        line.mode = .cubicBezier
        line.drawCirclesEnabled = false
        line.lineWidth = 3
        line.setColor(UIColor(named: color)!)
        line.fill = Fill(color: UIColor(named: fillColor)!)
        line.fillAlpha = fillAlpha
        line.drawFilledEnabled = false
        line.drawHorizontalHighlightIndicatorEnabled = false
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
