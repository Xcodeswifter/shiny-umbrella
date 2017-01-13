//
//  LogFiltersTableViewCell.swift
//  GCTRACKV2BETA
//
//  Created by Carlos Torres on 01/12/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class LogFiltersTableViewCell: UITableViewCell {

   
    @IBOutlet weak var pumpSwitch: UISwitch!
    @IBOutlet weak var pumpLabel: UILabel!
    @IBOutlet weak var pumpImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
