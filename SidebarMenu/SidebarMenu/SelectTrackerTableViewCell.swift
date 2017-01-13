//
//  SelectTrackerTableViewCell.swift
//  GCTRACKV2
//  Represents a cell of the tracker table
//  Created by Carlos Torres on 9/20/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import UIKit

class SelectTrackerTableViewCell: UITableViewCell {

    @IBOutlet weak var business: UILabel!
    @IBOutlet weak var locationbusiness: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
