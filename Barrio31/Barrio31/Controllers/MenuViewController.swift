//
//  MenuViewController.swift
//  Barrio31
//
//  Created by air on 08/10/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class MenuViewController: BaseViewController {
  
  var tableView: UITableView!
  let sections = ["Recorré" , "Disfrutá" , "Conocé" , "Participá"]
  let colors = [UIColor.hexStringToUIColor(hex: "de316a"),UIColor.hexStringToUIColor(hex: "f9a61d") , UIColor.hexStringToUIColor(hex: "1fc3f3"), UIColor.hexStringToUIColor(hex: "2fb463")]
    
    var recorre: MapViewController!
    var disfruta: DisfrutaViewController!
    var conoce: ConoceViewController!
    var participa: ParticipaViewController!

  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    view.addSubview(tableView)
    tableView.anchor(self.view.topAnchor, leading: nil, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor , size: .init(300, 0))
    tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
    tableView.estimatedRowHeight = 70.0
    tableView.rowHeight = 70.0
    tableView.separatorStyle = .none

    let barButton = UIBarButtonItem.init(title: "BA Integración", style: .plain, target: self, action: #selector(MenuViewController.menuPressed))
    let titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black,
                               NSAttributedStringKey.font : UIFont.chalet(fontSize: 17)]
    barButton.setTitleTextAttributes(titleTextAttributes, for: .normal)
    barButton.setTitlePositionAdjustment(UIOffset.init(horizontal: -145, vertical: 0), for: .default)
    self.navigationItem.rightBarButtonItem = barButton
    // Do any additional setup after loading the view.
    
    addFooterViewTableView()
  }
    
    func addFooterViewTableView() {
        
        //Adding switcher to locally download app data
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        customView.backgroundColor = UIColor.white
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.font = UIFont.chalet(fontSize: 14)
        label.textColor = UIColor(red:0.96, green:0.59, blue:0.17, alpha:1.0)
        label.text = "Descarga a local"
        label.frame.origin.x = customView.bounds.minX + 20
        label.frame.origin.y = customView.bounds.maxY
        label.sizeToFit()
   
        let switcher = UISwitch(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        switcher.backgroundColor = .white
        switcher.onTintColor = UIColor(red:0.96, green:0.59, blue:0.17, alpha:1.0)
        switcher.thumbTintColor = UIColor(red:0.96, green:0.59, blue:0.17, alpha:1.0)
        
        switcher.center.x = customView.bounds.maxY
        switcher.center.y = label.center.y
        
        switcher.setOn(true, animated: false)

        switcher.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        customView.addSubview(switcher)
        customView.addSubview(label)
        
        tableView.tableFooterView = customView
    }
    
    @objc func switchChanged(_ sender : UISwitch!){
        
        if sender.isOn {
            SDImageCache.shared().config.shouldCacheImagesInMemory = true
        } else {
            SDImageCache.shared().clearMemory()
            SDImageCache.shared().clearDisk()
            SDImageCache.shared().config.shouldCacheImagesInMemory = false
        }        
    }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}



extension MenuViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier:"cell")
    cell?.textLabel?.text = sections[indexPath.row]
    cell?.textLabel?.textColor = colors[indexPath.row]
    cell?.textLabel?.font = UIFont.chalet(fontSize: 30)
    
    return cell!
  }
  
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    

    return sections.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    switch indexPath.row {
        
    case 0:
        sideMenuController?.setContentViewController(with: "mapViewController")
    case 1:
        
        if disfruta == nil {
      disfruta = DisfrutaViewController()
      let nav = UINavigationController.init(rootViewController: disfruta)
      sideMenuController?.contentViewController = nav
        } else {
        sideMenuController?.setContentViewController(with: "disfrutaViewController")
        }

    case 2:
        
        if conoce == nil {
        conoce = ConoceViewController()
        let nav = UINavigationController.init(rootViewController: conoce)
        sideMenuController?.contentViewController = nav
            
        } else {
        sideMenuController?.setContentViewController(with: "conoceViewController")
        }
        
    case 3:
        
        if participa == nil {
        participa = ParticipaViewController()
        let nav = UINavigationController.init(rootViewController: participa)
        sideMenuController?.contentViewController = nav
            
        } else {
        sideMenuController?.setContentViewController(with: "participaViewController")
        }
    default:
      return
    }
    
    sideMenuController?.hideMenu()
  }
}

