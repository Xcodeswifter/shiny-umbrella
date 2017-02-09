//
//  LastTenEngineRunsTableViewCell.swift
//  GCTRACKV2BETA
//
//  Created by Carlos Torres on 08/11/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class LastTenEngineRunsTableViewCell: UITableViewCell {

    @IBOutlet weak var pumpImageLabel: UIImageView!
    @IBOutlet weak var stopLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var opTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
