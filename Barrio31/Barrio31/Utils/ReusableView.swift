//
//  ReusableView.swift
//  MiCountry
//
//  Created by Tomás Fernández on 15/5/17.
//  Copyright © 2017 Tomás Fernández Nuñez. All rights reserved.
//

import UIKit

protocol ReusableView: class { }

extension ReusableView where Self: UIView {
  
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}
