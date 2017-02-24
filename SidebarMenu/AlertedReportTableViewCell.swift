//
//  AlertedReportTableViewCell.swift
//  GCTRACKV2BETA
//
//  Created by user on 1/31/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class AlertedReportTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeBroadcastLabel: UILabel!
    @IBOutlet weak var forwardArrow: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
