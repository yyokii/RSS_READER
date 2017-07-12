//
//  ProfileTableViewCell.swift
//  RSS-READER
//
//  Created by 東原与生 on 2016/08/10.
//  Copyright © 2016年 yoki. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setBackImageView()
        setIconImageView()
        setNameLabel()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBackImageView () {
        backImageView.image = UIImage(named: "cover.png")
        backImageView.contentMode = UIViewContentMode.scaleAspectFill
        backImageView.clipsToBounds = true
        
    }
    
    func setIconImageView () {
        iconImageView.image = UIImage(named:  "pug.png")
        iconImageView.contentMode = UIViewContentMode.scaleAspectFill
        iconImageView.clipsToBounds = true
        iconImageView.layer.borderWidth = 2
        iconImageView.layer.borderColor = UIColor.white.cgColor
        iconImageView.layer.cornerRadius = 5
        
    }
    
    func setNameLabel () {
        nameLabel.text = "YYokii"
        nameLabel.font = UIFont(name: "HiraKakePron-W3", size: 35)
        nameLabel.textColor = UIColor.white
        
    }
    
}
