//
//  MapDetailViewController.swift
//  Barrio31
//
//  Created by air on 05/10/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SVProgressHUD
import AVKit
import AVFoundation
import Kingfisher
import Gemini

class MapDetailViewController: BaseViewController {
    
    var detail : PolygonDetail!
    
    var droneBeforeImg: UIImage!
    var droneAfterImg: UIImage!
    var streetBeforeImg: UIImage!
    var streetAfterImg: UIImage!
    
    var collectionView: GeminiCollectionView!
    
    var streetImageArray = [UIImage]()
    var droneImageArray = [UIImage]()
    
    var bottomView : UIView!
    var pageControl : UIPageControl!
    var ayerLabel : UILabel!
    var hoyLabel : UILabel!
    var mañanaLabel : UILabel!
    var infoButton : UIButton!
    var videoButton : UIButton!
    var infoView : UIView!
    
    var pageCounter: Int! = 0

    fileprivate var currentIndex = 0
    
    
    //MARK: Life Cycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNavBarDefault()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarClear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setImagesView {
            self.collectionView.reloadData()
            SVProgressHUD.dismiss()
        }
        
        bottomView = UIView()
        self.view.addSubview(bottomView)
        bottomView.backgroundColor = UIColor.color(0, g: 0, b: 0, a: 0.5)
        bottomView.anchor(nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor , size : .init(0, 60))
        
        infoButton = UIButton()
        infoButton.setTitle("Info", for: .normal)
        infoButton.setTitleColor(UIColor.white, for: .normal)
        infoButton.titleLabel?.font =  UIFont.chalet(fontSize: 16)
        infoButton.setImage(#imageLiteral(resourceName: "ic-info"), for: .normal)
        infoButton.imageEdgeInsets = .init(top: 0, left: -40, bottom: 0, right:0)
        infoButton.addTarget(self, action: #selector(MapDetailViewController.infoPressed), for: .touchUpInside)
        bottomView.addSubview(infoButton)
        
        infoButton.anchor(bottomView.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, size : .init(view.width/2, 60))
        
        videoButton = UIButton()
        videoButton.setTitle("Video", for: .normal)
        videoButton.setTitleColor(UIColor.white, for: .normal)
        videoButton.titleLabel?.font =  UIFont.chalet(fontSize: 16)
        videoButton.setImage(#imageLiteral(resourceName: "ic-video"), for: .normal)
        videoButton.imageEdgeInsets = .init(top: 0, left: -40, bottom: 0, right: 0)
        bottomView.addSubview(videoButton)
        videoButton.addTarget(self, action: #selector(MapDetailViewController.videoPressed), for: .touchUpInside)
        videoButton.anchor(bottomView.topAnchor, leading: infoButton.trailingAnchor, bottom: nil, trailing: nil, size : .init(view.width/2, 60))
        
        self.view.addSubview(pageControl)
        if #available(iOS 11.0, *) {
            pageControl.anchor(view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor , size : .init(0, 40))
        } else {
            // Fallback on earlier versions
            pageControl.anchor(view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor , size : .init(0, 40))
        }
        
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .lightGray
        
        ayerLabel = UILabel()
        ayerLabel.text = "AYER"
        ayerLabel.textColor = UIColor.white
        ayerLabel.textAlignment = .center
        ayerLabel.font = UIFont.chalet(fontSize: 16)
        self.view.addSubview(ayerLabel)
        
        ayerLabel.anchor(pageControl.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, size : .init(view.width/3, 30))
        
        
        mañanaLabel = UILabel()
        //Setting the current state of Item
        if detail.state == "FUTURE" {
            mañanaLabel.text = "MAÑANA"
        } else {
            mañanaLabel.text = "HOY"
        }
        
        mañanaLabel.alpha = 0.5
        mañanaLabel.textColor = UIColor.white
        mañanaLabel.textAlignment = .center
        mañanaLabel.font = UIFont.chalet(fontSize: 16)
        self.view.addSubview(mañanaLabel)
        mañanaLabel.anchor(pageControl.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, size : .init(view.width/3, 30))
        
    }
    
    func playVideUrl(url: String) {
        
        guard let url = URL(string: url)  else {
            return
        }
        
        let asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: item)
        
        let controller = AVPlayerViewController()
        controller.player = player
        self.addChildViewController(controller)
        self.view.addSubview(controller.view)
        controller.view.frame = self.view.frame
        
        player.play()
    }
    
    func downloadVideo(url: String){
        
        Alamofire.request(url).downloadProgress(closure : { (progress) in
            print(progress.fractionCompleted)
            SVProgressHUD.showProgress(Float(progress.fractionCompleted))
        }).responseData{ (response) in
            print(response)
            print(response.result.value!)
            print(response.result.description)
            if let data = response.result.value {
                
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let videoURL = documentsURL.appendingPathComponent("video.mp4")
                do {
                    try data.write(to: videoURL)
                    
                    print(videoURL)
                    
                    let asset = AVAsset(url: videoURL)
                    let item = AVPlayerItem(asset: asset)
                    let player = AVPlayer(playerItem: item)
                
                    
                    let controller = AVPlayerViewController()
                    controller.player = player
                    self.addChildViewController(controller)
                    self.view.addSubview(controller.view)
                    controller.view.frame = self.view.frame
                    
                    SVProgressHUD.dismiss()
                    
                    player.play()
                    
                } catch {
                    print("Something went wrong!")
                }
            }
        }
    }
    
    @objc func videoPressed() {
        if let videoURL =  detail.videoUrl {
            let urlString = videoURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            downloadVideo(url: urlString!)
//            playVideUrl(url: "http://barrio31.candoit.com.ar/api/multimedia/video-download/1470/4a243ac6-a63d-441f-a609-0dbddc919ea0_this.mp4.mp4?access_token=eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG1pbiJ9.F0jfyuausMz2uHyzVWaXDExMGQfcgMAZRn-wVv540zCVlknYjSjg3fAatsru9HVOL7xiqpZcUB4eHQjlSIWpUw")

        }
        else {
            SVProgressHUD.showError(withStatus: "No hay video disponible")
        }
    }
    
    @objc func infoPressed() {
        if infoView == nil {
            createInfoView()
        }else {
            UIView.animate(withDuration: 0.3) {
                self.infoView.alpha = 1.0
            }
        }
    }
    
    @objc func infoViewPressed() {
        UIView.animate(withDuration: 0.3) {
            self.infoView.alpha = 0.0
        }
    }
    
    func setNavBarClear() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage() //remove pesky 1 pixel line
    }
    
    func setNavBarDefault() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .black
        navigationController?.view.backgroundColor = UIColor.white
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage) -> Void) {
        print("Download Started")
        var image = UIImage()
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                image = UIImage(data: data)!
                completion(image)
            }
        }
    }

    func setImagesView(completion: @escaping () -> ())  {
        
        SVProgressHUD.show()
        
        let queue = DispatchQueue(label: "reverseDomain", attributes: .concurrent, target: .main)
        let group = DispatchGroup()

        
        if detail.street != nil {
            pageCounter += 1
            
            if let urlBefore = URL(string: detail.street!.beforeLink) {
                
                group.enter()
                downloadImage(from: urlBefore) { (image) in
                    queue.async (group: group) {
                        self.self.streetBeforeImg = image
                        group.leave()
                    }
                }
            }
            
            if let urlAfter = URL(string: detail.street!.afterLink) {
                
                group.enter()
                downloadImage(from: urlAfter) { (image) in
                    queue.async (group: group) {
                        self.self.streetAfterImg = image
                        group.leave()
                    }
                }
            }
            
        }
            
        if detail.drone != nil {
            pageCounter += 1
            
            if let urlBefore = URL(string: detail.drone!.beforeLink) {
                
                group.enter()
                downloadImage(from: urlBefore) { (image) in
                    queue.async (group: group) {
                        self.self.droneBeforeImg = image
                        group.leave()
                    }
                }
            }
            
            if let urlAfter = URL(string: detail.drone!.afterLink) {
                
                group.enter()
                downloadImage(from: urlAfter) { (image) in
                    queue.async (group: group) {
                        self.self.droneAfterImg = image
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: DispatchQueue.main) {
                
                self.streetImageArray.append(self.streetBeforeImg)
                self.streetImageArray.append(self.streetAfterImg)
                self.droneImageArray.append(self.droneBeforeImg)
                self.droneImageArray.append(self.droneAfterImg)

                completion()
            }            
        }
        
        pageControl = UIPageControl()
        pageControl.numberOfPages = pageCounter
        pageControl.currentPage = 0
        automaticallyAdjustsScrollViewInsets = false
        
        let direction: UICollectionView.ScrollDirection = .horizontal

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = direction
        
        collectionView = GeminiCollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.register(StreetCollectionViewCell.self, forCellWithReuseIdentifier: "StreetCollectionViewCell")
        collectionView.register(DroneCollectionViewCell.self, forCellWithReuseIdentifier: "DroneCollectionViewCell")
        collectionView.backgroundColor = .white

        configureAnimation()

        collectionView.fillSuperview()
        view.addSubview(collectionView)
        
    }
    
    
    func createInfoView() {
        infoView = UIView()
        self.view.addSubview(infoView)
        infoView.backgroundColor = UIColor.white
        infoView.anchor(view.centerYAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: -80, left: 10.0, bottom: -10.0, right: -10.0))
        
        let imgView = UIImageView()
        imgView.image = CategoryHelper.setImagePatternForCategory(categorySlug: detail.categorySlug!)
        imgView.contentMode = .scaleAspectFill
        infoView.addSubview(imgView)
        
        let tagLabel = UILabel()
        tagLabel.text = detail.categoryName
        tagLabel.font = UIFont.boldSystemFont(ofSize: 18)
        tagLabel.textColor = UIColor.white
        tagLabel.textAlignment = .left
        //tagLabel.font = UIFont.chalet(fontSize: 16)
        imgView.addSubview(tagLabel)
        tagLabel.anchor(imgView.topAnchor, leading: imgView.leadingAnchor, bottom: nil, trailing: imgView.trailingAnchor, padding: .init(top: 10.0, left: 20.0, bottom: 0.0, right: -20.0), size: .init(0, 18.0))
        
        let nameLabel = UILabel()
        nameLabel.text = detail.name
        nameLabel.textColor = detail.getColor()
        nameLabel.padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        nameLabel.backgroundColor = UIColor.white
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.chalet(fontSize: 18)
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.setContentHuggingPriority(.required, for: .vertical)
        imgView.addSubview(nameLabel)
        nameLabel.anchor(tagLabel.bottomAnchor, leading: imgView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10.0, left: 20.0, bottom: 0.0, right: 0.0), size: .init(0, 20.0))
        nameLabel.sizeToFit()
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = detail.shortDescription
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = UIFont.chalet(fontSize: 16)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.setContentHuggingPriority(.required, for: .vertical)
        imgView.addSubview(descriptionLabel)
        descriptionLabel.anchor(nameLabel.bottomAnchor, leading: imgView.leadingAnchor, bottom: nil, trailing: imgView.trailingAnchor, padding: .init(top: 10.0, left: 20.0, bottom: 0, right: -20.0))
        descriptionLabel.sizeToFit()
        
        imgView.clipsToBounds = true
        imgView.anchor(infoView.topAnchor, leading: infoView.leadingAnchor, bottom: descriptionLabel.bottomAnchor, trailing: infoView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 10.0, right: 0))
        
        let dateImgView = UIImageView()
        dateImgView.image = UIImage.init(named: "ic-fechas")
        dateImgView.contentMode = .scaleAspectFit
        infoView.addSubview(dateImgView)
        dateImgView.anchor(imgView.bottomAnchor, leading: infoView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10.0, left: 20.0, bottom: 0.0, right: 0.0), size: .init(20, 20.0))
        
        let dateLabel = UILabel()
        dateLabel.text = "Inicio: \(detail.started!) | Finalizado: \(detail.ended!)"
        dateLabel.textColor = UIColor.lightGray
        dateLabel.textAlignment = .left
        dateLabel.font = UIFont.chalet(fontSize: 14)
        infoView.addSubview(dateLabel)
        dateLabel.anchor(imgView.bottomAnchor, leading: dateImgView.trailingAnchor, bottom: nil, trailing: infoView.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 0) ,size: .init(0, 20.0))
        
        let montoImgView = UIImageView()
        montoImgView.image = UIImage.init(named: "ic-montos")
        montoImgView.contentMode = .scaleAspectFit
        infoView.addSubview(montoImgView)
        montoImgView.anchor(dateLabel.bottomAnchor, leading: infoView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10.0, left: 20.0, bottom: 0.0, right: 0.0), size: .init(20, 20.0))
        
        let montoLabel = UILabel()
        montoLabel.text = "Monto: $\(detail.amountStr!)"
        montoLabel.textColor = UIColor.lightGray
        montoLabel.textAlignment = .left
        montoLabel.font = UIFont.chalet(fontSize: 14)
        infoView.addSubview(montoLabel)
        montoLabel.anchor(dateImgView.bottomAnchor, leading: montoImgView.trailingAnchor, bottom: nil, trailing: infoView.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 0) ,size: .init(0, 20.0))
        
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        infoView.addSubview(line)
        line.anchor(montoLabel.bottomAnchor, leading: infoView.leadingAnchor, bottom: nil, trailing: infoView.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: -20), size: .init(width: 0, height: 0.5))
        
        
        let neighborsLabel = UILabel()
        neighborsLabel.text = detail.neighbors
        neighborsLabel.textColor = detail.getColor()
        neighborsLabel.textAlignment = .left
        neighborsLabel.font = UIFont.chalet(fontSize: 28)
        infoView.addSubview(neighborsLabel)
        neighborsLabel.anchor(line.bottomAnchor, leading: infoView.leadingAnchor, bottom: nil, trailing: infoView.trailingAnchor, padding: .init(top: 30, left: 10, bottom: 0, right: 10) ,size: .init(width: 0, height: 30))
        
        let neighborsTextLabel = UILabel()
        neighborsTextLabel.text = detail.neighborsText
        neighborsTextLabel.textColor = UIColor.black
        neighborsTextLabel.textAlignment = .left
        neighborsTextLabel.font = UIFont.chalet(fontSize: 16)
        neighborsTextLabel.numberOfLines = 0
        neighborsTextLabel.adjustsFontSizeToFitWidth = true
        neighborsTextLabel.minimumScaleFactor = 0.5
        
        infoView.addSubview(neighborsTextLabel)
        neighborsTextLabel.anchor(neighborsLabel.bottomAnchor, leading: infoView.leadingAnchor, bottom: nil, trailing: infoView.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: -10) ,size: .init(width: 0, height: 34))
        
        let m2Label = UILabel()
        m2Label.text = detail.m2
        m2Label.textColor = detail.getColor()
        m2Label.textAlignment = .left
        m2Label.font = UIFont.chalet(fontSize: 28)
        infoView.addSubview(m2Label)
        m2Label.anchor(neighborsTextLabel.bottomAnchor, leading: infoView.leadingAnchor, bottom: nil, trailing: infoView.trailingAnchor, padding: .init(top: 30, left: 10, bottom: 0, right: 10) ,size: .init(width: 0, height: 30))
        
        let m2LabelTextLabel = UILabel()
        m2LabelTextLabel.text = detail.m2Text
        m2LabelTextLabel.textColor = UIColor.black
        m2LabelTextLabel.textAlignment = .left
        m2LabelTextLabel.font = UIFont.chalet(fontSize: 16)
        m2LabelTextLabel.numberOfLines = 2
        infoView.addSubview(m2LabelTextLabel)
        m2LabelTextLabel.anchor(m2Label.bottomAnchor, leading: infoView.leadingAnchor, bottom: nil, trailing: infoView.trailingAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: -10) ,size: .init(width: 0, height: 34))
        
        
        infoView.setCellShadow()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(MapDetailViewController.infoViewPressed))
        infoView.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MapDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.animateVisibleCells()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Change the page indicator
        
        if pageCounter > 1 {
        if currentIndex == 0 {
            currentIndex = 1
        } else if currentIndex == 1 {
            currentIndex = 0
        }
    }
        
        self.pageControl.currentPage = currentIndex
    }
    
}



//MARK: ScrollView Cubic Animation Set
extension MapDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCounter
    }
    
    // Call animation function
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? GeminiCell {
            self.collectionView.animateCell(cell)
        }
    }
    
    // Configure animation and properties
    func configureAnimation() {
        collectionView.gemini
            .cubeAnimation()
            .shadowEffect(.fadeIn)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = GeminiCell()
        
        if indexPath.item == 0
        {
            // Configure For Street Cell
            let cellStreet = collectionView.dequeueReusableCell(withReuseIdentifier: "StreetCollectionViewCell", for: indexPath) as! StreetCollectionViewCell
            cellStreet.delegate = self
            cellStreet.imageArray = streetImageArray
            cell = cellStreet
        }
        else
        {
            // Configure For Drone Cell
            let cellDrone = collectionView.dequeueReusableCell(withReuseIdentifier: "DroneCollectionViewCell", for: indexPath) as! DroneCollectionViewCell
            cellDrone.delegate = self
            cellDrone.imageArray = droneImageArray
            cell = cellDrone
        }
        
        self.collectionView.animateCell(cell)
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MapDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension MapDetailViewController: StreetCellInteractionDelegate, DroneCellInteractionDelegate  {
    func scrollWasTapped() {
        setLabelAlpha()
    }
    
    func scrollWasTap() {
        setLabelAlpha()
    }
    
    func setLabelAlpha() {
        if ayerLabel.alpha == 0.5 {
            ayerLabel.alpha = 1
            mañanaLabel.alpha = 0.5
        } else if ayerLabel.alpha == 1 {
            ayerLabel.alpha = 0.5
            mañanaLabel.alpha = 1
        }
    }
    
}


