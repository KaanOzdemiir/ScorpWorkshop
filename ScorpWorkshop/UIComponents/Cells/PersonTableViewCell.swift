//
//  PersonTableViewCell.swift
//  ScorpWorkshop
//
//  Created by Kaan Ozdemir on 30.08.2021.
//  Copyright © 2021 Kaan Ozdemir. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    static let cellIdentifier = "PersonTableViewCell"
    static let nibName = "PersonTableViewCell"
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
