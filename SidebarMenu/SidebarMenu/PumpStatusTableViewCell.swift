//
//  PumpStatusTableViewCell.swift
//  GCTRACKV2
//  Class used to represent the an cell of the pumpstatus table
//  Created by Carlos Torres on 9/9/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import UIKit

class PumpStatusTableViewCell: UITableViewCell {

    @IBOutlet weak var pumpicon: UIImageView!
    @IBOutlet weak var pumptext: UILabel!
    @IBOutlet weak var pumpStatusText: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
