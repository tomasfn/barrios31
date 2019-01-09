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
import CoreLocation

class MapViewController: BaseViewController , UICollectionViewDataSource , UICollectionViewDelegate, MKMapViewDelegate {
    
    var mapView: MKMapView!
    var collectionView: UICollectionView!
        
    var infoView: InfoView!
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    var categorys = [Category]()
    var polygons = [Polygon]()
    var polygonsDetails = [PolygonDetail]()
    
    var segmentedControl: UISegmentedControl!
    
    var lastInfoViewId: Int!
    var selectedIndexs = [Int]()
    let villa31 = CLLocation(latitude: -34.582800, longitude: -58.379679)
    let regionRadius: CLLocationDistance = 1000
    
    private var selectedPol: B31Polyline!
    
    private var mapLayerBtn: UIButton!
    private var mapLocationBtn: UIButton!
    var mapState: Int = 0
    
    //MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupViews()
        setUpAppearance()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "RECORRE"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setLocationConfig()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addLocationAndLayerBtns()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
        
        sideMenuController?.cache(viewController: navigationController!, with: "mapViewController")
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
        self.title = "RECORRE"
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
        addMenuButton()
        
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
        loadData()
        centerMapOnLocation(location: villa31)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MapViewController.tapOnMap(sender:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.mapView.addGestureRecognizer(tapGesture)
        
        infoView = InfoView()
        infoView.backgroundColor = UIColor.white
        self.view.addSubview(infoView)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            infoView.anchor(nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 10, bottom: -20 , right: 10), size: .init(350, 95))
        }
        if UIDevice.current.userInterfaceIdiom == .phone {
            infoView.anchor(nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 15, bottom: -20 , right: -15), size: .init(0, 95))
        }
    
        infoView.alpha = 0.0
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(MapViewController.infoViewPressed))
        infoView.addGestureRecognizer(tap)
  
    }
    
    @objc func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func loadData() {
        SVProgressHUD.show()
        APIManager.getRecorreCategorys { (cats, error) in
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
    
    func addLocationAndLayerBtns() {
        
        if mapLayerBtn == nil {
        
        mapLayerBtn = UIButton(frame:CGRect(x: 20,
                                                       y: 20,
                                                       width: 55,
                                                       height: 55
        ))
        mapLayerBtn.showsTouchWhenHighlighted = true
        mapLayerBtn.setImage(UIImage.layersMap(), for: .normal)
        mapLayerBtn.setImage(UIImage.layersMap()?.maskWithColor(color: .lightGray), for: .highlighted)
        let tapA = UITapGestureRecognizer.init(target: self, action: #selector(MapViewController.setMap))
        mapLayerBtn.addGestureRecognizer(tapA)
        mapLayerBtn.roundView()
        mapLayerBtn.contentMode = .scaleAspectFit
        mapLayerBtn.backgroundColor = .white
        
        mapView.addSubview(mapLayerBtn)
        }
        
        
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
    
    @objc func setMap() {
       
        if self.mapState == 0 {
            self.mapState = 1
        } else if self.mapState == 1 {
            self.mapState = 0
        }
        
        self.setMapState(optionId: self.mapState)
    }
    
    @objc func centerOnUserLocation() {
        
        if currentLocation != nil {
            centerMapOnLocation(location: currentLocation!)
        }
    }
    
    func setMapState(optionId: Int!) {
        switch optionId {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        default:
            mapView.mapType = .hybrid
        }
    }
    
    func loadPolygons() {
        APIManager.getPolygons { (pols, error) in
            if let polys = pols , polys.count > 0 {
                self.polygons.removeAll()
                for pol in polys {
                    self.polygons.append(pol)
                    self.loadPolygonsDetails("\(pol.id)")
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
            if var det = details {
                if let pol = self.polygons.first(where: {$0.id == det.id}) {
                    det.color = pol.color
                }
                self.polygonsDetails.append(det)
                
            }
            else {
                //Show Error
                SVProgressHUD.showError(withStatus: "Error al descargar datos")
            }
        }
        )
    }
    
    func setUpAppearance() {
        let mainColor = UIColor.hexStringToUIColor(hex: "#f9a61d")
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().barTintColor = UIColor.white
        
        let titleTextAttributes = [NSAttributedStringKey.foregroundColor : mainColor,
                                   NSAttributedStringKey.font : UIFont.chalet(fontSize: 17)]
        UINavigationBar.appearance().titleTextAttributes  = titleTextAttributes
        
    }
    
    //MARK: MAPVIEW Methods
    
    func removeDrawMap() {
        mapView.removeOverlays(mapView.overlays)
    }
    
    func drawMap() {
        removeDrawMap()
        for index in selectedIndexs {
            let item = categorys [index]
            for pol in polygons {
                if pol.category == item.slug {
                    let polygon = B31Polyline(coordinates: pol.coordinates, count: pol.coordinates.count)
                    polygon.color = item.getColor().withAlphaComponent(0.5)
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
                
                infoView.category = polygon.category

                    selectedPol = B31Polyline(coordinates: (polygon.polygon?.coordinates)!, count: polygon.polygon!.coordinates.count)
                    selectedPol.color = polygon.category?.getColor()
                    selectedPol.category = polygon.category
                    selectedPol.polygon = polygon.polygon
                
                    self.mapView.add(selectedPol)
                
                if let det = polygonsDetails.first(where: {$0.id == polygon.polygon?.id}) {
                    infoView.detail = det
                }
                
                UIView.animate(withDuration: 0.3) {
                    self.infoView.alpha = 1
                    
                    if self.infoView.detail?.id != self.lastInfoViewId {
                        self.infoView.center.y -= self.infoView.frame.height
                    }
                    
                }
                
                lastInfoViewId = polygon.polygon?.id
                
                return
            }
            else {
                
                if selectedPol != nil {
                    self.mapView.remove(selectedPol)
                }
                
                UIView.animate(withDuration: 0.3) {
                    self.infoView.alpha = 0.0
                }
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
        let map = MapDetailViewController()
        map.detail = infoView.detail
        self.navigationController?.pushViewController(map, animated: true)
    }
    
}

// MARK - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        mapView.showsUserLocation = true
    }
}


//MARK: MKPolygon

class B31Polyline: MKPolygon {
    var color: UIColor?
    var category: Category?
    var polygon: Polygon?
}
