//
//  CalendarCollectionViewCell.swift
//  TemperatureBlanket
//
//  Created by Angelina Olmedo on 3/22/21.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp() {
        print("boutta set up")
        let lbl = UILabel()
        self.addSubview(lbl)
        
        lbl.text = "h"
        print("setting up done")
    }

}
