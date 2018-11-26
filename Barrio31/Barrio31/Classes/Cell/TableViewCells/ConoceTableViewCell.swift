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
    @IBOutlet weak var mainImgView: UIImageView!
    
    override func awakeFromNib() {
        roundCorners(8)

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
