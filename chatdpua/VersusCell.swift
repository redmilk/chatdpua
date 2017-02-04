//
//  VersusCell.swift
//  Marslink
//
//  Created by Artem on 2/3/17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import UIKit

class VersusCell: UICollectionViewCell {
    
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var imageTwo: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var titleOneLabel: UILabel!
    @IBOutlet weak var titleTwoLabel: UILabel!
    @IBOutlet weak var labelVS: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageOne.image = UIImage(named: "photoalbum")
        imageTwo.image = UIImage(named: "photoalbum")
    }
}
