//
//  ChatTableViewCell.swift
//  chatdpua
//
//  Created by Artem on 1/24/17.
//  Copyright © 2017 ApiqA. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    var gradient: CAGradientLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /*
        // Initialization code
        gradient = CAGradientLayer()
        gradient.colors = [UIColor.blue.cgColor, UIColor.white.cgColor]
        gradient.locations = [0.0 , 0.5]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
        gradient.zPosition = -10
        self.contentView.layer.addSublayer(gradient) */
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
