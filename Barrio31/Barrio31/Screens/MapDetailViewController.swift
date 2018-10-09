//
//  MapDetailViewController.swift
//  Barrio31
//
//  Created by air on 05/10/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import UIKit

class MapDetailViewController: BaseViewController {
  
  var detail : PolygonDetail? = nil
  var imgView: UIImageView!
  var bottomView : UIView!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    imgView = UIImageView()
    self.view.addSubview(imgView)
    imgView.fillSuperview()
    imgView.backgroundColor = UIColor.orange
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
