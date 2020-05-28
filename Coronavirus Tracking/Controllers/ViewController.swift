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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }



}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}



