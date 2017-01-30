//
//  ShoppingTableViewCell.swift
//  SPORK
//
//  Created by Kimberly Skipper on 1/29/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit

class ShoppingTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var shoppingItemTextField: UITextField!

    @IBOutlet weak var checkboxButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
