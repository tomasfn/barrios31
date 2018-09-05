//
//  NibLoadableView.swift
//  MiCountry
//
//  Created by Tomás Fernández on 15/5/17.
//  Copyright © 2017 Tomás Fernández Nuñez. All rights reserved.
//

import UIKit

protocol NibLoadableView: class { }

extension NibLoadableView where Self: UIView {
  
  static var nibName: String {
    return String(describing: self)
  }
  
  static var nib: UINib {
    return UINib(nibName: nibName, bundle: nil)
  }
}
