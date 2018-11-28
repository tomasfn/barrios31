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

class ConoceViewController: BaseViewController {
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none


        addMenuButton()
        self.title = "CONOCÉ"
        setUpAppearance()
        
        let cellNib = UINib.init(nibName: "ConoceTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ConoceTableViewCell")
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConoceTableViewCell", for: indexPath) as! ConoceTableViewCell
        cell.mainImgView.image = UIImage.patternHealth()
        
        return cell
    }
    
}
