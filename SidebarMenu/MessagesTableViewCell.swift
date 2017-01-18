//
//  MessagesTableViewCell.swift
//  GCTRACKV2BETA
//
//  Created by user on 1/16/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var bodyLabel: UITextView!
    @IBOutlet weak var theDateLabel: UILabel!
    
    @IBOutlet weak var isReadImage: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
