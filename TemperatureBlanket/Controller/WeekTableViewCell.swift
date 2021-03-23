//
//  WeekTableViewCell.swift
//  TemperatureBlanket
//
//  Created by Angelina Olmedo on 3/22/21.
//

import UIKit

class WeekTableViewCell: UITableViewCell {
    
    static var identifier: String = "PLACEHOLDER"

    static var nib: UINib {
           return UINib(nibName: String(describing: self), bundle: nil)
    }

    func setCell() {
        print("making the cell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
