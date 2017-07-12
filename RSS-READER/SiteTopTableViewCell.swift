//
//  SiteTopTableViewCell.swift
//  RSS-READER
//
//  Created by 東原与生 on 2016/08/07.
//  Copyright © 2016年 yoki. All rights reserved.
//

import UIKit

class SiteTopTableViewCell: UITableViewCell {
    @IBOutlet weak var siteImageView: UIImageView!
    @IBOutlet weak var imageMaskView: UIView!
    @IBOutlet weak var siteName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setSiteImageView()
        setImageMaskView()
        setNameLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSiteImageView (){
        self.siteImageView.contentMode = UIViewContentMode.scaleAspectFill
        self.siteImageView.layer.masksToBounds = true
        
    }
    
    func setImageMaskView(){
        self.imageMaskView.alpha = 0.6
    
    }
    
    func setNameLabel(){
        self.siteName.textColor = UIColor.white
        self.siteName.textAlignment = NSTextAlignment.center
        self.siteName.font =  UIFont(name: "Helvetica-Light", size: 40)
        
    }
    
}
