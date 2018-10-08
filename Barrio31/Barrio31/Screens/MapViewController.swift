//
//  ViewController.swift
//  Barrio31
//
//  Created by air on 21/08/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import UIKit
import MapKit
import SVProgressHUD

class MapViewController: BaseViewController , UICollectionViewDataSource , UICollectionViewDelegate, MKMapViewDelegate {
  
  var mapView: MKMapView!
  var collectionView: UICollectionView!
  var infoView: InfoView!

  var categorys = [Category]()
  var polygons = [Polygon]()
  var polygonsDetails = [PolygonDetail]()
  
  var selectedIndexs = [Int]()
  let villa31 = CLLocation(latitude: -34.582800, longitude: -58.379679)
  let regionRadius: CLLocationDistance = 1000
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    setupViews()
  }
  
  func setupViews () {
    self.title = "RECORRE"
    mapView = MKMapView()
    mapView.delegate = self
    
    self.view.addSubview(mapView)
    if #available(iOS 11.0, *) {
      mapView.anchor(view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom:view.bottomAnchor, trailing: view.trailingAnchor , padding: .init(top: 80, left: 0, bottom: 0, right: 0))
    } else {
      // Fallback on earlier versions
      mapView.anchor(view.topAnchor, leading: view.leadingAnchor, bottom:view.bottomAnchor, trailing: view.trailingAnchor , padding: .init(top: 80, left: 0, bottom: 0, right: 0))
    }
    addMenuButton()
    let flowLayout = UICollectionViewFlowLayout()
    collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.delegate = self
    collectionView.dataSource = self
    flowLayout.scrollDirection = .horizontal
    flowLayout.estimatedItemSize = .init(100, 80)
    flowLayout.minimumInteritemSpacing = 0
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
    collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "collectionCell")
    loadData()
    centerMapOnLocation(location: villa31)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MapViewController.tapOnMap(sender:)))
    tapGesture.numberOfTapsRequired = 1
    tapGesture.numberOfTouchesRequired = 1
    self.mapView.addGestureRecognizer(tapGesture)
    
    infoView = InfoView()
    infoView.backgroundColor = UIColor.white
    self.view.addSubview(infoView)
    infoView.anchor(nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 10, bottom: -20 , right: 10), size: .init(355, 80))
    infoView.alpha = 0.0
    
    let tap = UITapGestureRecognizer.init(target: self, action: #selector(MapViewController.infoViewPressed))
    infoView.addGestureRecognizer(tap)
  }
  
  func centerMapOnLocation(location: CLLocation) {
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
    mapView.setRegion(coordinateRegion, animated: true)
  }
  
  func loadData() {
    SVProgressHUD.show()
    APIManager.getCategorys { (cats, error) in
      if let _ = cats {
        self.categorys = cats!
        self.collectionView.reloadData()
        self.loadPolygons()
      }
      else {
        //Show Error
        SVProgressHUD.dismiss()
        SVProgressHUD.showError(withStatus: "Error al descargar datos")
      }
    }
  }
  
  func loadPolygons() {
    APIManager.getPolygons { (pols, error) in
      if let polys = pols , polys.count > 0 {
        self.polygons.removeAll()
        for pol in polys {
          self.polygons.append(pol)
          self.loadPolygonsDetails("\(pol.id!)")
          //print(" id a descrgar \(pol.id!)")
        }
        SVProgressHUD.dismiss()
      }
      else {
        //Show Error
        SVProgressHUD.dismiss()
        SVProgressHUD.showError(withStatus: "Error al descargar datos")
      }
    }
  }
  
  func loadPolygonsDetails(_ id:String) {
    APIManager.getPolygonsDetails(withId: id, completionBlock: { (details, error) in
      if let det = details {
        self.polygonsDetails.append(det)
      }
      else {
        //Show Error
        SVProgressHUD.showError(withStatus: "Error al descargar datos")
      }
    }
    )
  }
  
  
  
  //MARK: MAPVIEW Methods
  
  func drawMap() {
    mapView.removeOverlays(mapView.overlays)
    for index in selectedIndexs {
      let item = categorys [index]
      for pol in polygons {
        if pol.category == item.slug {
          let polygon = B31Polyline(coordinates: pol.coordinates, count: pol.coordinates.count)
          polygon.color = item.getColor()
          polygon.category = item
          polygon.polygon = pol
          self.mapView.add(polygon)
        }
      }
    }
  }
  
  @objc func tapOnMap(sender: UITapGestureRecognizer) {
    //if sender.state != UIGestureRecognizerState.Began { return }
    let touchLocation = sender.location(in: mapView)
    let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
    
    
    let point = MKMapPointForCoordinate(locationCoordinate)
    let mapRect = MKMapRectMake(point.x, point.y, 0, 0);
    
    for polygon in mapView.overlays as! [B31Polyline] {
      if polygon.intersects(mapRect) {//Touch in polygon
        infoView.alpha = 1.0
        infoView.category = polygon.category
        if let det = polygonsDetails.first(where: {$0.id == polygon.polygon?.id}) {
          infoView.detail = det
        }
        return
      }
      else {
        infoView.alpha = 0.0
      }
    }
  }
  
  func contains(polygon: [CGPoint], test: CGPoint) -> Bool {
    if polygon.count <= 1 {
      return false //or if first point = test -> return true
    }
    
    let p = UIBezierPath()
    let firstPoint = polygon[0] as CGPoint
    
    p.move(to: firstPoint)
    
    for index in 1...polygon.count-1 {
      p.addLine(to: polygon[index] as CGPoint)
    }
    
    p.close()
    
    return p.contains(test)
  }
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let polygonRenderer = MKPolygonRenderer(overlay: overlay)
    
    polygonRenderer.fillColor = UIColor.white
    if let polyline = overlay as? B31Polyline {
      polygonRenderer.fillColor = polyline.color!
    }
    
    return polygonRenderer
  }
  
  //MARK: CollectionView Methods
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
    return self.categorys.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
  {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath ) as! CategoryCell
    let item = categorys[indexPath.item]
    cell.isPressed = selectedIndexs.contains(indexPath.item)
    cell.item = item
    return cell
  }
  
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if selectedIndexs.contains(indexPath.item) {
      selectedIndexs.removeObject(indexPath.item)
    }else {
      selectedIndexs.append(indexPath.item)
    }
    drawMap()
    collectionView.reloadData()
  }
  
  @objc func infoViewPressed () {
    
  }
  
  
  
}
//MARK: CollectionViewCell

class CategoryCell: UICollectionViewCell {
  
  var item : Category? {
    didSet {
      if isPressed {
        container.backgroundColor = item!.getColor()
        label.textColor = UIColor.white
        imgView.image = item!.getImageOn()
      }
      else {
        container.backgroundColor = UIColor.white
        label.textColor = UIColor.gray
        imgView.image = item!.getImageOff()
      }
      label.text = item!.name
    }
  }
  
  var isPressed = false
  
  let imgView: UIImageView = {
    let iv = UIImageView()
    iv.clipsToBounds = true
    iv.contentMode = .scaleAspectFit
    iv.backgroundColor = UIColor.clear
    return iv
  }()
  
  let container: UIView = {
    let iv = UIView()
    iv.backgroundColor = UIColor.clear
    return iv
  }()
  
  let label: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.darkGray
    label.font = UIFont.systemFont(ofSize: 12)
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setup()
  }
  
  func setup() {
    //setCellShadow()
    addSubview(container)
    addSubview(imgView)
    addSubview(label)
    container.anchor(topAnchor, leading: leadingAnchor, bottom:bottomAnchor, trailing:trailingAnchor,size: .init(100, 80.0))
    
    //label.anchor(imgView.bottomAnchor, leading: leadingAnchor, bottom:bottomAnchor, trailing:trailingAnchor)
    label.anchor(nil, leading: nil, bottom:bottomAnchor, trailing:nil,size: .init(88, 30.0))
    label.anchorCenterXToSuperview()
    imgView.anchor(topAnchor, leading: leadingAnchor, bottom:label.topAnchor, trailing:trailingAnchor)
    imgView.anchorCenterXToSuperview()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

//MARK: MKPolygon

class B31Polyline: MKPolygon {
  var color: UIColor?
  var category: Category?
  var polygon: Polygon?
}

//MARK: infoView

class InfoView: UIView {
  
  var category : Category? {
    didSet {
      labelName.backgroundColor = category!.getColor()
    }
  }
  
  var detail : PolygonDetail? {
    didSet {
      labelName.text = detail?.name
      labelCategory.text = detail?.categoryName
      labelDescription.text = detail?.shortDescription
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
  
  let labelCategory: UILabel = {
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
    addSubview(labelCategory)
    addSubview(labelDescription)
    labelCategory.anchor(topAnchor,
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

