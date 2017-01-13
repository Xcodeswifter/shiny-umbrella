//
//  SystemInfoTableViewCell.swift
//  GCTRACKV2
//
//  Created by Carlos Torres on 10/27/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import UIKit

class SystemInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var pumpDescription: UITextView!
    @IBOutlet weak var pumpLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
