//
//  PurchaseTableViewCell.swift
//  Device Statistic
//
//  Created by Alexsander  on 2/6/16.
//  Copyright © 2016 Alexsander Khitev. All rights reserved.
//

import UIKit

class PurchaseTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.userInteractionEnabled = true
            descriptionLabel.highlighted = true
        }
    }
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
