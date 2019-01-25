//
//  DisfrutaViewController.swift
//  Barrio31
//
//  Created by air on 19/10/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import UIKit
import MapKit
import SVProgressHUD

class DisfrutaViewController: BaseViewController, UICollectionViewDelegateFlowLayout {
  
  var mapView: MKMapView!
  var tableView: UITableView!
  var mapButton: UIButton!
  var listButton: UIButton!
  var infoView: DisfrutaInfoView!

    var collectionView: UICollectionView!

  var items = [DisfrutaItem]()
  var details = [DisfrutaDetail]()
    var selectedDetails = [DisfrutaDetail]()
  var currentItem : DisfrutaItem?

var lastInfoViewId: Int!
    
    var selectedIndexs = [Int]()
    var categorys = [Category]()
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    let villa31 = CLLocation(latitude: -34.582800, longitude: -58.379679)
    let regionRadius: CLLocationDistance = 1000
    
    private var mapLocationBtn: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView = UITableView()
    self.view.addSubview(tableView)
    tableView.fillSuperview()
    tableView.dataSource = self
    tableView.delegate = self
    addMenuButton()
    self.title = "DISFRUTÁ"
    setUpAppearance() 
    
    self.loadData()
    
//    mapView = MKMapView()
//    self.view.addSubview(mapView)
//
//    mapView.delegate = self
//    mapView.fillSuperview()
//    mapView.alpha = 1.0
    tableView.alpha = 0.0
    
    // Do any additional setup after loading the view.
    mapButton = UIButton()
    mapButton.setBackgroundImage(#imageLiteral(resourceName: "ic-mapa-inactivo"), for: .normal)
    mapButton.setBackgroundImage(#imageLiteral(resourceName: "ic-mapa-activo"), for: .selected)
    mapButton.anchorCenterSuperview()
    mapButton.widthAnchor.constraint(equalToConstant: 37.0)
    mapButton.heightAnchor.constraint(equalToConstant: 37.0)
    mapButton.addTarget(self, action: #selector(DisfrutaViewController.mapButtonpressed), for: .touchUpInside)
    let mapButtonItem = UIBarButtonItem.init(customView: mapButton)
    mapButton.isSelected = true
    
    
    listButton = UIButton()
    listButton.setBackgroundImage(#imageLiteral(resourceName: "ic-lista-inactivo"), for: .normal)
    listButton.setBackgroundImage(#imageLiteral(resourceName: "ic-lista-activo"), for: .selected)
    listButton.addTarget(self, action: #selector(DisfrutaViewController.listButtonpressed), for: .touchUpInside)
    listButton.anchorCenterSuperview()
    listButton.widthAnchor.constraint(equalToConstant: 37.0)
    listButton.heightAnchor.constraint(equalToConstant: 37.0)
    let listButtonItem = UIBarButtonItem.init(customView: listButton)
    listButton.isSelected = false
    self.navigationItem.rightBarButtonItems = [listButtonItem , mapButtonItem]
    
    infoView = DisfrutaInfoView()
    infoView.backgroundColor = UIColor.white
    self.view.addSubview(infoView)
    infoView.anchor(nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 10, bottom: -20 , right: 10), size: .init(355, 80))
    infoView.alpha = 0.0
    
    let tap = UITapGestureRecognizer.init(target: self, action: #selector(MapViewController.infoViewPressed))
    infoView.addGestureRecognizer(tap)
    
    //add gesture to infoview to closes itself
    
    let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
    infoView.addGestureRecognizer(gesture)
    infoView.isUserInteractionEnabled = true
    gesture.delegate = self
    
    tableView.register(DisfrutaTableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 140
    tableView.separatorStyle = .none
    
    getCategories()
    setupViews()
    
  }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.reloadData()
        addLocationMapBtn()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setLocationConfig()
        centerMapOnLocation(location: villa31)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "DISFRUTA"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
        sideMenuController?.cache(viewController: navigationController!, with: "disfrutaViewController")
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func setLocationConfig() {
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check for Location Services
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func setupViews () {
        self.title = "DISFRUTA"
        mapView = MKMapView()
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        self.view.addSubview(mapView)
        if #available(iOS 11.0, *) {
            mapView.anchor(view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom:view.bottomAnchor, trailing: view.trailingAnchor , padding: .init(top: 80, left: 0, bottom: 0, right: 0))
        } else {
            // Fallback on earlier versions
            mapView.anchor(view.topAnchor, leading: view.leadingAnchor, bottom:view.bottomAnchor, trailing: view.trailingAnchor , padding: .init(top: 80, left: 0, bottom: 0, right: 0))
        }
        
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.estimatedItemSize = .init(100, 80)
        flowLayout.minimumInteritemSpacing = 0
        
        // minimumLineSpacing para los items debajo
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsetsMake(0.0, 0.0,00,0);
        self.view.addSubview(collectionView)
        
        if #available(iOS 11.0, *) {
            collectionView.anchor(view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom:mapView.topAnchor, trailing: view.trailingAnchor)
        } else {
            // Fallback on earlier versions
            collectionView.anchor(view.topAnchor, leading: view.leadingAnchor, bottom:mapView.topAnchor, trailing: view.trailingAnchor)
        }
        
        collectionView.backgroundColor = UIColor.white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "collectionCell")
        
        self.view.bringSubview(toFront: infoView)
    }
    
    func addLocationMapBtn() {
        if mapLocationBtn == nil {
            
            mapLocationBtn = UIButton(frame:CGRect(x: mapView.bounds.maxX - 80, y: collectionView.bounds.height - 60, width: 55, height: 55))
            
            mapLocationBtn.showsTouchWhenHighlighted = true
            mapLocationBtn.setImage(UIImage.centerOnLocation(), for: .normal)
            mapLocationBtn.setImage(UIImage.centerOnLocation()?.maskWithColor(color: .lightGray), for: .highlighted)
            let tapB = UITapGestureRecognizer.init(target: self, action: #selector(MapViewController.centerOnUserLocation))
            mapLocationBtn.addGestureRecognizer(tapB)
            mapLocationBtn.roundView()
            mapLocationBtn.contentMode = .scaleAspectFit
            mapLocationBtn.backgroundColor = .white
            
            mapView.addSubview(mapLocationBtn)
        }
    }
    
    func getCategories() {
        SVProgressHUD.show()
        APIManager.getDisfrutaCategorys { (cats, error) in
            if let _ = cats {
                self.categorys = cats!
                self.collectionView.reloadData()
            }
            else {
                //Show Error
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "Error al descargar datos")
            }
        }
    }
    
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.began || gestureRecognizer.state == UIGestureRecognizerState.changed {
            if case .Down = gestureRecognizer.verticalDirection(target: self.view) {
                print("Swiping info down")
                let translation = gestureRecognizer.translation(in: self.view)
                print(gestureRecognizer.view!.center.y)
                dismiss(animated: true, completion: nil)
                UIView.animate(withDuration: 0.3){
                    self.infoView.alpha = 0.0
                    print("info dismiss")
                }
            }
        }
    }
  
  func setUpAppearance() {
    let mainColor = UIColor.hexStringToUIColor(hex: "#de316a")
    UINavigationBar.appearance().tintColor = UIColor.black
    UINavigationBar.appearance().barTintColor = UIColor.white
    
    let titleTextAttributes = [NSAttributedStringKey.foregroundColor : mainColor,
                               NSAttributedStringKey.font : UIFont.chalet(fontSize: 17)]
    UINavigationBar.appearance().titleTextAttributes  = titleTextAttributes
  }
    
  
  @objc func mapButtonpressed () {
    if mapButton.isSelected == false {
      mapButton.isSelected = true
      listButton.isSelected = false
      mapView.alpha = 1.0
      tableView.alpha = 0.0
        collectionView.alpha = 1.0
    }
  }
    
    @objc func centerOnUserLocation() {
        if currentLocation != nil {
            centerMapOnLocation(location: currentLocation!)
        }
    }
  
  @objc func listButtonpressed () {
    if listButton.isSelected == false {
      listButton .isSelected = true
      mapButton.isSelected = false
      mapView.alpha = 0.0
      tableView.alpha = 1.0
      infoView.alpha = 0.0
        collectionView.alpha = 0.0
    }
  }
    
    @objc func showListAnimated () {
        if listButton.isSelected == false {
            listButton .isSelected = true
            mapButton.isSelected = false
            mapView.alpha = 0.0
            infoView.alpha = 0.0
            collectionView.alpha = 0.0
            
            tableView.alpha = 1
            tableView.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
                //use if you want to darken the background
                //self.viewDim.alpha = 0.8
                //go back to original form
                self.tableView.transform = .identity
            })
            
//            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
//                self.tableView.alpha = 1.0
//            }) { (isCompleted) in
//            }
//
//            UIView.animate(withDuration: 0.5, delay: 0.25, options: UIViewAnimationOptions(), animations: { () -> Void in
//                self.tableView.alpha = 1.0
//            }, completion: { (finished: Bool) -> Void in
//
//            })
        }
    }
  
  func loadData() {
    SVProgressHUD.show()
    APIManager.getDisfruta { (disfrutaItems, error) in
      //SVProgressHUD.dismiss()
      if error == nil {
        self.items.append(contentsOf: disfrutaItems!)
        //self.tableView.reloadData()
        //self.addPins()
        self.loadDetails()
      }
      else {
        SVProgressHUD.showError(withStatus: error?.localizedDescription)
      }
    }
  }
  
  func loadDetails() {
    var counter = items.count
    for item in items {
      counter = counter - 1
      //print("\(counter)")
        APIManager.getDisfrutaDetails(withId: "\(String(describing: item.id))") { (disf, error) in
        if error == nil {
          self.details.append(disf!)
          if self.details.count == self.items.count , counter == 0 {
            SVProgressHUD.dismiss()
            self.tableView.reloadData()
            //self.addPins()
          }
          else {
            if counter != 0 {
              SVProgressHUD.dismiss()
              SVProgressHUD.showError(withStatus: ErrorManager.unknownError().localizedDescription)
            }
          }
        }
        else {
          SVProgressHUD.showError(withStatus: error?.localizedDescription)
        }
      }
    }
  }
  
  func addPins () {
    for item in items {
      if let coord = item.coordinate {
        if let det = details.first(where: { ($0.id == item.id)}) {
          let ann = DisfrutaAnnotation.init(coordinate: coord, title: item.name!, subtitle: "", item: item)
          mapView.addAnnotation(ann)
        }
       
      }
      
    }
    mapView.showAnnotations(mapView.annotations, animated: true)
    
  }
    
    func addFilteredPins() {
        removeMapAnnotations()
        selectedDetails.removeAll()
        for index in selectedIndexs {
            let category = categorys [index]
            for item in items {
                for detail in item.details {
                    if detail.categorySlug == category.slug {
                        if let coord = item.coordinate {
                            if let det = details.first(where: { ($0.id == item.id)}) {
                                selectedDetails.append(detail)
                                tableView.reloadData()
                                let ann = DisfrutaAnnotation.init(coordinate: coord, title: item.name!, subtitle: "", item: item)
                                mapView.addAnnotation(ann)
                            }
                        }
                    }
                }
            }
            
           // mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    func removeMapAnnotations() {
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
    }
  
  @objc func infoViewPressed () {
    //print("infoViewPressed")
//    let det = DisfrutaDetailViewController()
//    //map.detail = infoView.detail
//
//    det.item = infoView.disfrutaDetail
    
    if infoView.disfrutaItem.details.count == 1 {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DisfrutaDetailViewController") as! DisfrutaDetailViewController
        
        controller.item = infoView.disfrutaItem.details.first
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    } else {
        showListAnimated()
    }
    
    print("",infoView.disfrutaItem.details)
    
    //controller.item = infoView.disfrutaItem.details
    
    //let det = DisfrutaDetailViewController()
    //map.detail = infoView.detail
    //det.item = details[indexPath.row]
   // self.navigationController?.pushViewController(controller, animated: true)
    
  }
  
}

extension DisfrutaViewController : UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DisfrutaTableViewCell
    cell.dateLabel.text = selectedDetails[indexPath.row].ended
    cell.item = selectedDetails[indexPath.row]
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedDetails.count
  }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DisfrutaDetailViewController") as! DisfrutaDetailViewController
        controller.item = selectedDetails[indexPath.row]

        //let det = DisfrutaDetailViewController()
        //map.detail = infoView.detail
        //det.item = details[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension DisfrutaViewController : MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    if annotation is MKUserLocation {
        return nil
    }
    
    let annotationView = CustomPointAnnotationView(annotation: annotation, reuseIdentifier: "Attraction")
    annotationView.canShowCallout = false
    if let ann = annotation as? DisfrutaAnnotation {
      annotationView.item = ann.item
    }
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    if let ann = view as? CustomPointAnnotationView {
      print("Seleccionó \(String(describing: ann.item?.name))")
        
        infoView.disfrutaItem = ann.item
        selectedDetails = infoView.disfrutaItem.details
        tableView.reloadData()

        UIView.animate(withDuration: 0.3) {
            self.infoView.alpha = 1
            
            if self.infoView.disfrutaItem.id != self.lastInfoViewId {
                self.infoView.center.y -= self.infoView.frame.height
            }
        }
        
        lastInfoViewId = infoView.disfrutaItem.id
    }
  }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let ann = view as? CustomPointAnnotationView {
            print("Deseleccionó \(String(describing: ann.item?.name))")
            
            UIView.animate(withDuration: 0.3) {
                self.infoView.alpha = 0
            }

        }
    }
}

class CustomPointAnnotationView:  MKAnnotationView {
  var item: DisfrutaItem?

  // Required for MKAnnotationView
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)    
    image = #imageLiteral(resourceName: "disfruta-pin")
  }
}

class DisfrutaAnnotation: NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var title: String?
  var subtitle: String?
  var item: DisfrutaItem?
  
  init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, item: DisfrutaItem) {
    self.coordinate = coordinate
    self.title = title
    self.subtitle = subtitle
    self.item = item
  }
}


// MARK - CLLocationManagerDelegate

extension DisfrutaViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        mapView.showsUserLocation = true
    }
}

extension DisfrutaViewController: UIGestureRecognizerDelegate {}

extension DisfrutaViewController: UICollectionViewDataSource , UICollectionViewDelegate {
    
    //MARK: CollectionView Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.categorys.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath ) as! CategoryCell
        let item = categorys[indexPath.item]
        
        cell.resizeWidth(categoryFloat: CGFloat(categorys.count))
        cell.isPressed = selectedIndexs.contains(indexPath.item)
        cell.item = item
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("deselection")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedIndexs.contains(indexPath.item) {
            selectedIndexs.removeObject(indexPath.item)
        }else {
            selectedIndexs.append(indexPath.item)
        }
        
        addFilteredPins()
        
        collectionView.reloadData()
    }    
}

