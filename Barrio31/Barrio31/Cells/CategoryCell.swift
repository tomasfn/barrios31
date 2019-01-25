//
//  CategoryCell.swift
//  Barrio31
//
//  Created by air on 02/11/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import Foundation
import UIKit

//MARK: CollectionViewCell

class CategoryCell: UICollectionViewCell {
  
  var item : Category? {
    didSet {
      if isPressed {
        container.backgroundColor = item!.getColor()
        label.textColor = UIColor.white
        imgView.image = item!.getImageOn()
      }
      else {
        container.backgroundColor = UIColor.white
        label.textColor = UIColor.lightGray
        imgView.image = item!.getImageOff()
      }
      label.text = item!.name?.uppercased()
        
        //Ugly solution as client requested
        if item?.name == "Infraestructura" {
            label.text = "INFRAESTRU..."
        }
    }
  }
  
  var isPressed = false
    
    var categoriesQty: CGFloat?
  
  let imgView: UIImageView = {
    let iv = UIImageView()
    iv.clipsToBounds = true
    iv.contentMode = .scaleAspectFit
    iv.backgroundColor = UIColor.clear
    return iv
  }()
  
  let container: UIView = {
    let iv = UIView()
    iv.backgroundColor = UIColor.clear
    iv.clipsToBounds = true
    return iv
  }()
  
  let label: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.lightGray
    label.font = UIFont.chalet(fontSize: 12)
    label.textAlignment = .center
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 0
    return label
  }()
    
    let screenRect = UIScreen.main.bounds
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  func setup() {
    //setCellShadow()
    addSubview(container)
    addSubview(imgView)
    addSubview(label)
    
    // 1. request an UITraitCollection instance
    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
    // 2. check the idiom
    switch (deviceIdiom) {
        
    case .pad:
        width = 250
    case .phone:
        width = 100
    case .tv:
        print("tvOS style UI")
    default:
        print("Unspecified UI idiom")
    }
    
    container.anchor(topAnchor, leading: leadingAnchor, bottom:bottomAnchor, trailing:trailingAnchor,size: .init(width, 80.0))

    
    //label.anchor(imgView.bottomAnchor, leading: leadingAnchor, bottom:bottomAnchor, trailing:trailingAnchor)
    label.anchor(nil, leading: nil, bottom:bottomAnchor, trailing:nil,size: .init(88, 30.0))
    label.anchorCenterXToSuperview()
    imgView.anchor(topAnchor, leading: leadingAnchor, bottom:label.topAnchor, trailing:trailingAnchor , padding: .init(top: 10, left: 5, bottom: -5, right: -5))
    imgView.anchorCenterXToSuperview()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
    func resizeWidth(categoryFloat: CGFloat) {
        
        let screenWidth = screenRect.size.width
                
        width = screenWidth / categoryFloat
        
        container.anchor(topAnchor, leading: leadingAnchor, bottom:bottomAnchor, trailing:trailingAnchor,size: .init(width, 80.0))        
    }
  
}
