//
//  FeedTableViewCell.swift
//  Snapchat App Clone
//
//  Created by Yavuz Güner on 16.07.2022.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var feedUserNameLabel: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
