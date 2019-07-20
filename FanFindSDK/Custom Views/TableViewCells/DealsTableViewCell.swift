//
//  DealsTableViewCell.swift
//  FanFindSDK
//
//  Created by Christopher Woolum on 7/16/19.
//  Copyright © 2019 Turnoutt Inc. All rights reserved.
//

import UIKit

class DealsTableViewCell: UITableViewCell {
    @IBOutlet var icon: UIImageView!
    @IBOutlet var label: UILabel!
    
    var bundle = Bundle(for: DealsTableViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if(FanFindConfiguration.theme == .Light){
            icon.image = UIImage(named: "Deals_Icon_Gray", in: self.bundle, compatibleWith: nil)            
        }else{
            icon.image = UIImage(named: "Deals_Icon_White", in: self.bundle, compatibleWith: nil)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
