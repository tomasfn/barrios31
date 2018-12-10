//
//  ConoceTableViewCell.swift
//  Barrio31
//
//  Created by Tomás Fernandez Nuñez on 26/11/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import UIKit

class ConoceTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mainImgView: GSSimpleImageView!
    
    override func awakeFromNib() {
        roundCorners(8)
        mainImgView.roundCorners(8)
        
        titleLbl.textColor = .black
        titleLbl.backgroundColor = .white
        titleLbl.font = UIFont.chalet(fontSize: 18)
        titleLbl.lineBreakMode = .byClipping
        
        mainImgView.contentMode = .scaleAspectFill
        mainImgView.clipsToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(10, 10, 50, 10))
        selectionStyle = .none
    }
}
