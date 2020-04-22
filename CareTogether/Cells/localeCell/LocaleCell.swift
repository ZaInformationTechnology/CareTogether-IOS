//
//  LocaleCell.swift
//  CareTogether
//
//  Created by CodigoHeinHtet on 16/04/2020.
//  Copyright © 2020 HEINHTET. All rights reserved.
//

import UIKit

class LocaleCell: UITableViewCell {
    @IBOutlet weak var ivLogo: UIImageView!
    @IBOutlet weak var lbLocaleName: UILabel!
    
    @IBOutlet weak var lyCheck: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
