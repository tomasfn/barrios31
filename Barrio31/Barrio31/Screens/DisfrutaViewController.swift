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

class DisfrutaViewController: BaseViewController {
  
  var mapView: MKMapView!
  var tableView: UITableView!
  var mapButton: UIButton!
  var listButton: UIButton!
  var infoView: DisfrutaInfoView!


  var items = [DisfrutaItem]()
  var details = [DisfrutaDetail]()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView = UITableView()
    self.view.addSubview(tableView)
    tableView.fillSuperview()
    tableView.dataSource = self
    addMenuButton()
    self.title = "DISFRUTÁ"
    self.loadData()
    
    mapView = MKMapView()
    self.view.addSubview(mapView)
    mapView.delegate = self
    mapView.fillSuperview()
    mapView.alpha = 1.0
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
    
  }
  
  @objc func mapButtonpressed () {
    if mapButton.isSelected == false {
      mapButton.isSelected = true
      listButton.isSelected = false
      mapView.alpha = 1.0
      tableView.alpha = 0.0

    }
  }
  
  @objc func listButtonpressed () {
    if listButton.isSelected == false {
      listButton .isSelected = true
      mapButton.isSelected = false
      mapView.alpha = 0.0
      tableView.alpha = 1.0
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
      APIManager.getDisfrutaDetails(withId: "\(String(describing: item.id!))") { (disf, error) in
        if error == nil {
          self.details.append(disf!)
          if self.details.count == self.items.count , counter == 0{
            SVProgressHUD.dismiss()
            self.tableView.reloadData()
            self.addPins()
          }
          else {
            if counter == 0 {
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
          let ann = DisfrutaAnnotation.init(coordinate: coord, title: item.category!, subtitle: "", item: det)
          mapView.addAnnotation(ann)
        }
       
      }
      
    }
    mapView.showAnnotations(mapView.annotations, animated: true)
    
  }
  
  @objc func infoViewPressed () {
    print("infoViewPressed")
    //let map = MapDetailViewController()
    //map.detail = infoView.detail
    //self.navigationController?.pushViewController(map, animated: true)
  }
  
}

extension DisfrutaViewController : UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = items[indexPath.row].category
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
}

extension DisfrutaViewController : MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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
      infoView.disfrutaDetail = ann.item
      infoView.alpha = 1.0
    }
  }
}

class CustomPointAnnotationView:  MKAnnotationView {
  var item: DisfrutaDetail?

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
  var item: DisfrutaDetail?
  
  init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, item: DisfrutaDetail) {
    self.coordinate = coordinate
    self.title = title
    self.subtitle = subtitle
    self.item = item
  }
}

class DisfrutaInfoView: UIView {
  
  /*var category : Category? {
    didSet {
      labelName.backgroundColor = category!.getColor()
    }
  }*/
  
  
  
  var disfrutaDetail : DisfrutaDetail! {
    didSet {
      labelName.text = disfrutaDetail.name
      labelDescription.text = disfrutaDetail.shortDescription
      labelDate.text = disfrutaDetail.started! + " - " + disfrutaDetail.ended!
      //labelName.sizeToFit()
      
    }
  }
  
  
  let labelName: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.white
    label.backgroundColor = UIColor.darkGray
    label.font = UIFont.chalet(fontSize: 20)
    label.text = ""
    return label
  }()
  
  let labelDate: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.darkGray
    label.font = UIFont.chalet(fontSize: 15)
    label.textAlignment = .left
    label.text = ""
    return label
  }()
  
  let labelDescription: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.black
    label.font = UIFont.chalet(fontSize: 15)
    label.text = ""
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  func setup() {
    backgroundColor = UIColor.white
    setCellShadow()
    addSubview(labelName)
    addSubview(labelDate)
    addSubview(labelDescription)
    labelDate.anchor(topAnchor,
                         leading: centerXAnchor,
                         bottom:nil,
                         trailing:trailingAnchor,
                         padding: .init(top: 10, left: 10, bottom: -10, right: -10),
                         size: .init(frame.size.width/2, 30))
    labelName.anchor(topAnchor,
                     leading:leadingAnchor,
                     bottom:nil,
                     trailing:centerXAnchor,
                     padding: .init(top: 10, left: 10, bottom: -10, right: -10),
                     size: .init(frame.size.width/2, 30))
    
    labelDescription.anchor(nil,
                            leading: leadingAnchor,
                            bottom:bottomAnchor,
                            trailing:trailingAnchor,
                            padding:.init(top: 10, left: 10, bottom: -10, right: -10),
                            size: .init(0, 30))
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}




