//
//  SuperCommentTableViewCell.swift
//  chatdpua
//
//  Created by Artem on 1/27/17.
//  Copyright © 2017 ApiqA. All rights reserved.
//

import UIKit

class VSCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButtonPressed(_ sender: UIButton) {
    }
}
