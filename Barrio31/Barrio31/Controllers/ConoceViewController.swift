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
    
    private var conoceItems = [ConoceItem] ()
    
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
        }
        
        let imageViewerController = ImageViewerController(configuration: configuration)
        present(imageViewerController, animated: true)
    }
    
}
