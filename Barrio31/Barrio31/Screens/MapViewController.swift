//
//  ViewController.swift
//  Barrio31
//
//  Created by air on 21/08/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseViewController , UICollectionViewDataSource {

  var mapView: MKMapView!
  var collectionView: UICollectionView!
  var categorys = [Category]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    mapView = MKMapView()
    self.view.addSubview(mapView)
    self.title = "RECORRE"
    mapView.anchor(view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom:view.bottomAnchor, trailing: view.trailingAnchor , padding: .init(top: 60, left: 0, bottom: 0, right: 0))
    addMenuButton()
    let flowLayout = UICollectionViewFlowLayout()
    collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
    //collectionView.delegate = self
    collectionView.dataSource = self
    self.view.addSubview(collectionView)
    collectionView.anchor(view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom:mapView.topAnchor, trailing: view.trailingAnchor)
    collectionView.backgroundColor = UIColor.red
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")


    APIManager.getUser { (cats, error) in
      if let _ = cats {
        self.categorys = cats!
        self.collectionView.reloadData()
      }
      else {
        
      }
    }
  }

  //MARK: CollectionView Methods
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
    return self.categorys.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
  {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath )
    cell.backgroundColor = UIColor.green
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
  {
    return CGSize.init(50.0, 50.0)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
  {
    return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
  }



}

