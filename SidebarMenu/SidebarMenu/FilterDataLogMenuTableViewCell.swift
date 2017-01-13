//
//  FilterDataLogMenuTableViewCell.swift
//GCTRACKV2
//
//  Created by Carlos Torres on 9/22/16.
//  Copyright ©2016 GC-Track. All rights reserved.
//

import UIKit

class FilterDataLogMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var pumpicon: UIImageView!
    @IBOutlet weak var pumplabel: UILabel!
    @IBOutlet weak var isPumpSelected: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
            }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

            }

}
