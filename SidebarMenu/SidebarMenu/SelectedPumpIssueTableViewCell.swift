//
//  SelectedPumpIssueTableViewCell.swift
//  GCTRACKV2BETA
//
//  Created by Carlos Torres on 16/11/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class SelectedPumpIssueTableViewCell: UITableViewCell {

    @IBOutlet weak var pumpIssueText: UITextView!
    @IBOutlet weak var dateTimeText: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
