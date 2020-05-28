//
//  LiveReportsTableViewCell.swift
//  Coronavirus Tracking
//
//  Created by Yasin Shamrat on 15/5/20.
//  Copyright © 2020 Yasin Shamrat. All rights reserved.
//

import UIKit

class LiveReportsTableViewCell: UITableViewCell {

    @IBOutlet weak var countryFlagImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var currentTollLabel: UILabel!
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
