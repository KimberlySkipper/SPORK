//
//  IngredientTableViewCell.swift
//  SPORK
//
//  Created by Kimberly Skipper on 1/24/17.
//  Copyright © 2017 The Iron Yard. All rights reserved.
//

import UIKit

class IngredientTableViewCell: UITableViewCell
{
    @IBOutlet weak var ingredientTextField: UITextField?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
