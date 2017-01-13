//
//  LastTenDaysPressureTableViewCell.swift
//  
//
//  Created by Carlos Torres on 08/11/16.
//
//

import UIKit

class LastTenDaysPressureTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBOutlet weak var dateTimeText: UITextView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
