//
//  DisfrutaInfoView.swift
//  Barrio31
//
//  Created by air on 02/11/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import Foundation
import UIKit


class DisfrutaInfoView: UIView {
  
  var disfrutaItem : DisfrutaItem! {
    didSet {
      labelName.text = disfrutaItem.name
      labelDescription.text = disfrutaItem.address
      //labelDate.text = disfrutaDetail.started! + " - " + disfrutaDetail.ended!
      //labelName.sizeToFit()
      
    }
  }
  
  
  let labelName: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.white
    label.backgroundColor = UIColor.darkGray
    label.font = UIFont.chalet(fontSize: 20)
    label.text = ""
    return label
  }()
  
  let labelDate: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.darkGray
    label.font = UIFont.chalet(fontSize: 15)
    label.textAlignment = .left
    label.text = ""
    return label
  }()
  
  let labelDescription: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.black
    label.font = UIFont.chalet(fontSize: 15)
    label.text = ""
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  func setup() {
    backgroundColor = UIColor.white
    setCellShadow()
    addSubview(labelName)
    addSubview(labelDate)
    addSubview(labelDescription)
    labelDate.anchor(topAnchor,
                     leading: centerXAnchor,
                     bottom:nil,
                     trailing:trailingAnchor,
                     padding: .init(top: 10, left: 10, bottom: -10, right: -10),
                     size: .init(frame.size.width/2, 30))
    labelName.anchor(topAnchor,
                     leading:leadingAnchor,
                     bottom:nil,
                     trailing:centerXAnchor,
                     padding: .init(top: 10, left: 10, bottom: -10, right: -10),
                     size: .init(frame.size.width/2, 30))
    
    labelDescription.anchor(nil,
                            leading: leadingAnchor,
                            bottom:bottomAnchor,
                            trailing:trailingAnchor,
                            padding:.init(top: 10, left: 10, bottom: -10, right: -10),
                            size: .init(0, 30))
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}


