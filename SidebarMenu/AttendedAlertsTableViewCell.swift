//
//  AttendedAlertsTableViewCell.swift
//  GCTRACKV2BETA
//
//  Created by Apple on 02/02/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class AttendedAlertsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var isAttendedImage: UIImageView!
    
    @IBOutlet weak var forwardArrow: UIImageView!
    @IBOutlet weak var attendedDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
