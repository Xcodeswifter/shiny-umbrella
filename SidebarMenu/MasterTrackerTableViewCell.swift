//
//  MasterTrackerTableViewCell.swift
//  GCTRACKV2BETA
//
//  Created by Apple on 07/02/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class MasterTrackerTableViewCell: UITableViewCell {

    @IBOutlet weak var Business: UILabel!
    @IBOutlet weak var address: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
