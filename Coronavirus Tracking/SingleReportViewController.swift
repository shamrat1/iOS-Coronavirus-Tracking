//
//  SingleReportViewController.swift
//  Coronavirus Tracking
//
//  Created by Yasin Shamrat on 26/5/20.
//  Copyright © 2020 Yasin Shamrat. All rights reserved.
//

import UIKit

class SingleReportViewController: UIViewController {
    var country : Country?
    // url https://api.covid19api.com/country/bangladesh?from=2020-05-07T00:00:00Z&to=2020-05-14T00:00:00Z
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = country?.country
    }

    

}
