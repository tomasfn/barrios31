//
//  ConoceViewController.swift
//  Barrio31
//
//  Created by Tomás Fernandez Nuñez on 26/11/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import UIKit
import MapKit
import SVProgressHUD
import SimpleImageViewer
import Kingfisher

class ConoceViewController: BaseViewController {
    
    var tableView: UITableView!
    var floatingLbl: UILabel!
    
    private var conoceItems = [ConoceItem] ()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
        
        sideMenuController?.cache(viewController: navigationController!, with: "conoceViewController")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "CONOCE"
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        floatingLbl = UILabel(frame: CGRect(x: 30, y: 100, width: 240, height: 40))
        floatingLbl.textColor = .black
        floatingLbl.backgroundColor = .white
        floatingLbl.font = UIFont.chalet(fontSize: 18)
        floatingLbl.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)


        self.title = "CONOCÉ"
        
        addMenuButton()
        setUpAppearance()
        getConoceItems()
        
        let cellNib = UINib.init(nibName: "ConoceTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ConoceTableViewCell")
    }
    
    func getConoceItems() {
        SVProgressHUD.show()
        
        APIManager.getAllConoceItems { (cItems, error) in
            if error == nil {
                
                self.conoceItems = cItems!
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
            }
        }
    }
    
    func setUpAppearance() {
        let mainColor = UIColor.hexStringToUIColor(hex: "#006fb6")
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().barTintColor = UIColor.white
        
        let titleTextAttributes = [NSAttributedStringKey.foregroundColor : mainColor,
                                   NSAttributedStringKey.font : UIFont.chalet(fontSize: 17)]
        UINavigationBar.appearance().titleTextAttributes  = titleTextAttributes

    }

}

extension ConoceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conoceItems.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConoceTableViewCell", for: indexPath) as! ConoceTableViewCell
        
        let cItem = conoceItems[(indexPath as NSIndexPath).row]
        
        let url = URL(string: cItem.imgLink!)
        cell.mainImgView.kf.setImage(with: url)
        cell.titleLbl.text = cItem.name

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as? ConoceTableViewCell
        
        let configuration = ImageViewerConfiguration { config in
            config.imageView = cell?.mainImgView
            config.imageView?.roundCorners(radius: 8)
        }
        
        let imageViewerController = ImageViewerController(configuration: configuration)
        
        
        let cItem = conoceItems[(indexPath as NSIndexPath).row]
        floatingLbl.text = cItem.name
        floatingLbl.isHidden = false
        floatingLbl.minimumScaleFactor = 0.5
        floatingLbl.adjustsFontSizeToFitWidth = true
        
        imageViewerController.view.addSubview(floatingLbl)
        
        present(imageViewerController, animated: true)

    }
    
}
