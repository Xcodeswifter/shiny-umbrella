//
//  DataLoggedTableViewCell.swift
//  GCTRACKV2
// Represents a cell of the data log table
//  Created by Carlos Torres on 9/7/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import UIKit

class DataLoggedTableViewCell: UITableViewCell {

    @IBOutlet weak var statuslabel: UILabel!
    @IBOutlet weak var PressureLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!

    @IBOutlet weak var pressureValue: UILabel!
    @IBOutlet weak var dateValue: UILabel!

    @IBOutlet weak var statusLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
