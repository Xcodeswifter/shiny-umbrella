//
//  UsersTrackerTableViewCell.swift
//  GCTRACKV2BETA
//
//  Created by user on 1/31/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class UsersTrackerTableViewCell: UITableViewCell {

    @IBOutlet weak var trackerAddress: UILabel!
    @IBOutlet weak var TrackerName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
