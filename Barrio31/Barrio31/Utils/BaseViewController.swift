//
//  BaseViewController.swift
//  Madryn
//
//  Created by Esteban Vallejo on 21/9/15.
//  Copyright (c) 2015 CanDoIt. All rights reserved.
//

import UIKit
import SideMenuSwift
import SVProgressHUD

class BaseViewController: UIViewController {
  
  override internal var title: String? {
    get { return super.title }
    set { super.title = newValue }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    NSLog("** Memory warning! at view controller: %@", self)
  }
  
  func addMenuButton() {
    let menu = UIBarButtonItem.init(image: #imageLiteral(resourceName: "menu-ic"), style: .plain, target: self, action: #selector(BaseViewController.menuPressed))
    self.navigationItem.leftBarButtonItem = menu
  }
  
  @objc func menuPressed() {
    if (self.sideMenuController?.isMenuRevealed)! {
      self.sideMenuController?.hideMenu()
    } else {
      self.sideMenuController?.revealMenu()
    }
  }
  
  
  
}

//MARK: Private configuration
extension BaseViewController {
 
}

