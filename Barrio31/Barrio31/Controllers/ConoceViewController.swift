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
        addMenuButton()
        self.title = "CONOCÉ"
        setUpAppearance()
        
    }
    
    func setUpAppearance() {
        let mainColor = UIColor.hexStringToUIColor(hex: "#de316a")
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().barTintColor = UIColor.white
        
        let titleTextAttributes = [NSAttributedStringKey.foregroundColor : mainColor,
                                   NSAttributedStringKey.font : UIFont.chalet(fontSize: 17)]
        UINavigationBar.appearance().titleTextAttributes  = titleTextAttributes
    }

}

extension ConoceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    private func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.clear
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    let cell = tableView.dequeueReusableCell(withIdentifier: "ConoceTableViewCell") as? ConoceTableViewCell
        cell?.mainImgView.image = UIImage.patternHealth()
        cell?.titleLbl.text = "titulo"
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
