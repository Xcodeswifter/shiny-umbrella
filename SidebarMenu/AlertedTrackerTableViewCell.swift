//
//  AlertedTrackerTableViewCell.swift
//  GCTRACKV2
//
//  Created by Carlos Torres on 10/19/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import UIKit

class AlertedTrackerTableViewCell: UITableViewCell {

    @IBOutlet weak var alertedTrackerName: UILabel!
    @IBOutlet weak var alertedTrackerAddress: UILabel!
    @IBOutlet weak var dateAndPressure: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

            }

}
