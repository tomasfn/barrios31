//
//  DisfrutaTableViewCell.swift
//  Barrio31
//
//  Created by air on 31/10/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class DisfrutaTableViewCell: UITableViewCell {
  
  var item : DisfrutaDetail? {
    didSet {
      dateLabel.text = (item?.started)! + " - " + (item?.ended)!
      nameLabel.text = item?.name
      dateLabel.sizeToFit()
      descriptionLabel.text = item?.shortDescription
      priceLabel.text = item?.price
      imageView?.contentMode = .scaleAspectFit
      if let imgLink = item?.imageLink {
        let url = "http://barrio31.candoit.com.ar" + imgLink
        Alamofire.request(url).responseImage { response in
          if let image = response.result.value {
            self.imgView.image = image
          }
        }
      }
    }
  }
  
  
  let imgView: UIImageView = {
    let iv = UIImageView()
    iv.clipsToBounds = false
    iv.contentMode = .scaleAspectFit
    iv.backgroundColor = UIColor.white
    return iv
  }()
  
  let container: UIView = {
    let iv = UIView()
    iv.backgroundColor = UIColor.white
    iv.clipsToBounds = false
    return iv
  }()
  
  let dateLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = UIColor.lightGray
    label.textColor = UIColor.white
    label.font = UIFont.chalet(fontSize: 15)
    label.textAlignment = .left
    label.numberOfLines = 1
    label.lineBreakMode = .byWordWrapping
    label.setContentHuggingPriority(.required, for: .vertical)
    label.clipsToBounds = false
    return label
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = UIColor.white
    label.textColor = UIColor.hexStringToUIColor(hex: "f9a61d")
    label.font = UIFont.chalet(fontSize: 20)
    label.textAlignment = .left
    label.numberOfLines = 0
    label.clipsToBounds = false
    return label
  }()
  
  let descriptionLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = UIColor.white
    label.textColor = UIColor.black
    label.font = UIFont.chalet(fontSize: 16)
    label.textAlignment = .left
    label.numberOfLines = 1
    label.clipsToBounds = false
    return label
  }()
  
  let priceLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = UIColor.white
    label.textColor = UIColor.lightGray
    label.font = UIFont.chalet(fontSize: 16)
    label.textAlignment = .left
    label.numberOfLines = 1
    label.clipsToBounds = false
    return label
  }()
  
  let ticketImgView: UIImageView = {
    let iv = UIImageView()
    iv.image = UIImage.init(named: "ic-entradas")
    iv.contentMode = .scaleAspectFit
    iv.backgroundColor = UIColor.white
    return iv
  }()
  
  func setup() {
    //setCellShadow()
    addSubview(container)
    container.addSubview(imgView)
    container.addSubview(dateLabel)
    container.addSubview(nameLabel)
    container.addSubview(descriptionLabel)
    container.addSubview(priceLabel)
    container.addSubview(ticketImgView)


    container.anchor(topAnchor, leading: leadingAnchor, bottom:bottomAnchor, trailing:trailingAnchor, padding: .init(top: 10, left: 20, bottom: -10, right: -20), size:.init(width: 0, height: 140))
    imgView.anchor(container.topAnchor, leading: container.leadingAnchor, bottom:container.bottomAnchor, trailing:nil , size: .init(140, 140))
    dateLabel.anchor(imgView.topAnchor, leading: imgView.trailingAnchor, bottom:nil, trailing:container.trailingAnchor , padding: .init(top: 10, left: 10, bottom: 0, right: -10), size: .init(width: 0, height: 18))
    nameLabel.anchor(dateLabel.bottomAnchor, leading: imgView.trailingAnchor, bottom:nil, trailing:container.trailingAnchor ,padding: .init(top: 10, left: 10, bottom: 0, right: -10), size: .init(width: 0, height: 18))
    descriptionLabel.anchor(nameLabel.bottomAnchor, leading: imgView.trailingAnchor, bottom:nil, trailing:container.trailingAnchor , padding: .init(top: 10, left: 10, bottom: 0, right: -10), size: .init(width: 0, height: 18))
    
    ticketImgView.anchor(descriptionLabel.bottomAnchor, leading: imgView.trailingAnchor, bottom:nil, trailing:nil, padding: .init(top: 10, left: 10, bottom: 0, right: 0), size: .init(width: 20, height: 20))
    
    priceLabel.anchor(descriptionLabel.bottomAnchor, leading: ticketImgView.trailingAnchor, bottom:nil, trailing:container.trailingAnchor , padding: .init(top: 10, left: 10, bottom: 0, right: 0), size: .init(width: 0, height: 20))

    container.layer.shadowColor = UIColor.darkGray.cgColor
    container.layer.shadowOffset = CGSize(width: 0, height: 1)
    container.layer.shadowOpacity = 1
    container.layer.shadowRadius = 1.0
    container.layer.masksToBounds = true
    container.clipsToBounds = true
    container.layer.cornerRadius = 5
    container.layer.borderColor = UIColor.lightGray.cgColor
    container.layer.borderWidth = 0.5
  }
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    

  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
