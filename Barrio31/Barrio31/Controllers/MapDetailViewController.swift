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
import SDWebImage

class MapDetailViewController: BaseViewController {
    
    var detail : PolygonDetail!
    var infoDetailView: InfoView!
    var droneBeforeImg: UIImage!
    var droneAfterImg: UIImage!
    var streetBeforeImg: UIImage!
    var streetAfterImg: UIImage!
    
    var collectionView: GeminiCollectionView!
    
    var streetImageArray = [UIImage]()
    var droneImageArray = [UIImage]()
    
    var bottomView : UIView!
    var infoButton : UIButton!
    var videoButton : UIButton!
    var infoView : UIView!
   
    var pageControl : UIPageControl!
   
    var videoView : UIView!
    var controller: AVPlayerViewController!
    var player: AVPlayer!
    
    var pageCounter: Int! = 0
    fileprivate var currentIndex = 0
    
    let imageCache = NSCache<NSString, UIImage>()
    
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
            self.setPageControl()
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
        

        if  detail.videoUrl == nil && detail.shortDescription == "" {
            if detail.videoUrl == nil && detail.shortDescription == nil{
            videoButton.isEnabled = false
            infoButton.isEnabled = false
            }else{
                videoButton.isEnabled = false
                infoButton.isEnabled = false
            }
        }
        
        view.isUserInteractionEnabled = true
    }
    
    func setPageControl() {
        
        //Set Page Control
        pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = pageCounter
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .lightGray
        
        view.addSubview(pageControl)
        
        if #available(iOS 11.0, *) {
            pageControl.anchor(view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor , size : .init(0, 40))
        } else {
            // Fallback on earlier versions
            pageControl.anchor(view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor , size : .init(0, 40))
        }
        
        
    }
    
    func addDraggableGesture() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        infoView.addGestureRecognizer(gesture)
        infoView.isUserInteractionEnabled = true
        gesture.delegate = self
    }
    
    func addVideoDraggableGesture(){
        let gesture = UIPanGestureRecognizer(target: self, action: #selector (self.videoWasDragged(gestureRecognizer:)))
        self.videoView.addGestureRecognizer(gesture)
        videoView.isUserInteractionEnabled = true
        dismissViewController()
        gesture.delegate = self
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
    
    @objc func videoWasDragged(gestureRecognizer: UIPanGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.began || gestureRecognizer.state == UIGestureRecognizerState.changed {
            if case .Down = gestureRecognizer.verticalDirection(target: self.view) {
                print("Swiping Video down")
                let translation = gestureRecognizer.translation(in: self.view)
                print(gestureRecognizer.view!.center.y)
                dismiss(animated: true, completion: nil)
                UIView.animate(withDuration: 0.3) {
                    self.player.pause()
                    self.videoView.alpha = 0.0
                    print("video dismiss")
                }
            }
        }
    }
    
    
    enum UIUserInterfaceIdiom : Int{
        case unespecified
        case phone
        case pad
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func createVideoView(url: String){
        guard let url = URL(string: url) else{
            return
        }
        videoView = UIView()
        self.view.addSubview(videoView)
        videoView.backgroundColor = UIColor.init(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
        videoView.layer.cornerRadius = 8.0
        videoView.clipsToBounds = true
        
        let playerItem = CachingPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        let controller = AVPlayerViewController()
        controller.player = player
        self.addChildViewController(controller)
        videoView.addSubview(controller.view)
        //            self.view.addSubview(controller.view)
        //        controller.view.frame = self.view.frame
        
        controller.player = player
        controller.didMove(toParentViewController: self)
        
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            //******** VIDEO SIZE NUEVO *********
            videoView.anchor(view.topAnchor, leading: view.centerXAnchor , bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 15, left: -40, bottom: -20, right: -15))
            
            //**************** FrameSize ***********************
            controller.view.anchor(videoView.topAnchor, leading: videoView.leadingAnchor, bottom: videoView.bottomAnchor, trailing: videoView.trailingAnchor, padding: .init(top: 10, left:10, bottom: -15, right: -10))
            player.play()
            
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone {

            //******** VIDEO SIZE NUEVO *********
            videoView.anchor(view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 15, left: 15, bottom: -20, right: -15), size: .init(0,0))
         
            //**************** FrameSize ***********************
            controller.view.anchor(videoView.topAnchor, leading: videoView.leadingAnchor, bottom: videoView.bottomAnchor, trailing: videoView.trailingAnchor, padding: .init(top: 10, left: 10, bottom: -15, right: -10))
            player.play()
        }

        addVideoDraggableGesture()
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
                    self.player = AVPlayer(playerItem: item)
                    
                    self.controller = AVPlayerViewController()
                    self.controller.player = self.player
                    self.addChildViewController(self.controller)
                    self.view.addSubview(self.controller.view)
                    self.controller.view.frame = self.view.frame
                    
                    SVProgressHUD.dismiss()
                    
                    self.player.play()
                    
                } catch {
                    print("Something went wrong!")
                }
            }
        }
    }
    
    // OBJECT ORIGINAL!!
    
//    @objc func videoPressed() {
//        if let videoURL =  detail.videoUrl {
//            let urlString = videoURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
////            downloadVideo(url: urlString!)
//
//            playVideUrl(url: urlString!)
//        }
//        else {
//            SVProgressHUD.showError(withStatus: "No hay video disponible")
//        }
//    }
    
    // Video View
    @objc func videoPressed() {
        if videoView == nil{
            if let videoURL =  detail.videoUrl {
                let urlString = videoURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
                //            downloadVideo(url: urlString!)
            
                createVideoView(url: urlString!)
//                playVideUrl(url: urlString!)
            }
            else {
                SVProgressHUD.showError(withStatus: "No hay video disponible")
            }
        }else{
            UIView.animate(withDuration: 0.3) {
                self.videoView.alpha = 1.0
            }
        }
    }
    
    // Info View
    @objc func infoPressed() {
        if infoView == nil {
            if detail.shortDescription == "" || detail.shortDescription == nil{
                SVProgressHUD.showError(withStatus: "No hay info disponible")
            }
            else { 
                createInfoView()
            }
        }
            else {
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
        
//        let cacheKey = SDWebImageManager.shared().cacheKey(for: url)
        var finalImage = UIImage()
        
        print("Download Started")
        SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: url.absoluteString, done: { (image, data, cacheType) in
            if (image != nil) {
                completion(image!)
            } else {
                
                self.getData(from: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                    print(response?.suggestedFilename ?? url.lastPathComponent)
                    print("Download Finished")
                    DispatchQueue.main.async() {
                        finalImage = UIImage(data: data)!
                        SDImageCache.shared().store(finalImage, forKey: url.absoluteString)
                        completion(finalImage)
                    }
                }
            }
        })
    }

    func setImagesView(completion: @escaping () -> ())  {
        
        SVProgressHUD.show()
        
        let queue = DispatchQueue(label: "reverseDomain", attributes: .concurrent, target: .main)
        let group = DispatchGroup()

        
        if detail.street != nil {
            pageCounter += 1
            
            if let urlBefore = detail.street!.beforeLink {
                group.enter()

                let url = URL(string: urlBefore)
                downloadImage(from: url!) { (image) in
                    queue.async (group: group) {
                        self.self.streetBeforeImg = image
                        group.leave()
                        
                    }
                }
            }
            
            if let urlAfter = detail.street!.afterLink {
                group.enter()
                
                let url = URL(string: urlAfter)
                downloadImage(from: url!) { (image) in
                    queue.async (group: group) {
                        self.self.streetAfterImg = image
                        group.leave()
                    }
                }
            }
            
        }
            
        if detail.drone != nil {
            pageCounter += 1
            
            if let urlBefore = detail.drone!.beforeLink {
                group.enter()
                
                let url = URL(string: urlBefore)
                downloadImage(from: url!) { (image) in
                    queue.async (group: group) {
                        self.self.droneBeforeImg = image
                        group.leave()
                    }
                }
            }
            
            if let urlAfter = detail.drone!.afterLink {
                group.enter()
                
                let url = URL(string: urlAfter)
                downloadImage(from: url!) { (image) in
                    queue.async (group: group) {
                        self.self.droneAfterImg = image
                        group.leave()
                    }
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            
            if let imgSBefore = self.streetBeforeImg {
                self.streetImageArray.append(imgSBefore)
            }
            
            if let imgSAfter = self.streetAfterImg {
                self.streetImageArray.append(imgSAfter)
            }
            
            if let imgDBefore = self.droneBeforeImg {
                self.droneImageArray.append(imgDBefore)
            }
            
            if let imgDBAfter = self.droneAfterImg {
                self.droneImageArray.append(imgDBAfter)
            }
            
            completion()
        }
        
        automaticallyAdjustsScrollViewInsets = false
        
        let direction: UICollectionView.ScrollDirection = .horizontal

        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = direction
        
        collectionView = GeminiCollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.delegate   = self
        collectionView.dataSource = self
        
        // PROBANDO SWIPEVIEW en ipad .... 
        if UIDevice.current.userInterfaceIdiom == .pad {
        collectionView.register(StreetCollectionSwipeViewCell.self, forCellWithReuseIdentifier: "StreetCollectionViewCell")
        collectionView.register(DroneCollectionSwipeViewCell.self, forCellWithReuseIdentifier: "DroneCollectionViewCell")
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone {
        collectionView.register(StreetCollectionViewCell.self, forCellWithReuseIdentifier: "StreetCollectionViewCell")
        collectionView.register(DroneCollectionViewCell.self, forCellWithReuseIdentifier: "DroneCollectionViewCell")
        }
        
        collectionView.backgroundColor = UIColor(patternImage: CategoryHelper.setImagePatternForCategory(categorySlug: detail.categorySlug!))
        collectionView.decelerationRate = UIScrollViewDecelerationRateNormal

        configureAnimation()

        collectionView.fillSuperview()
        view.addSubview(collectionView)
        
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch: UITouch? = touches.first
//
//        if controller != nil {
//            if touch?.view != infoView {
//                infoView.isHidden = true
//            }
//
//            if touch?.view != controller {
//                if #available(iOS 11.0, *) {
//                    controller.exitsFullScreenWhenPlaybackEnds = true
//                } else {
//                    // Fallback on earlier versions
//                    print("you have an older version")
//                }
//            }
//        }
//    }
//
    
    func createInfoView() {
        
        infoView = UIView()
        self.view.addSubview(infoView)
        infoView.backgroundColor = UIColor.white
        
        let imgView = UIImageView()
        imgView.image = CategoryHelper.setImagePatternForCategory(categorySlug: detail.categorySlug!)
        imgView.contentMode = .scaleAspectFill
        infoView.addSubview(imgView)
        
        let tagLabel = UILabel()
        tagLabel.text = detail.categoryName?.uppercased()
        tagLabel.font = UIFont.chalet(fontSize: 16)
        tagLabel.textColor = UIColor.white
        tagLabel.numberOfLines = 0
        tagLabel.textAlignment = .left
        //tagLabel.font = UIFont.chalet(fontSize: 16)
        imgView.addSubview(tagLabel)
        tagLabel.anchor(imgView.topAnchor, leading: imgView.leadingAnchor, bottom: nil, trailing: imgView.trailingAnchor, padding: .init(top: 10.0, left: 20.0, bottom: 0.0, right: -20.0), size: .init(0, 18.0))
        
        let nameLabel = UILabel()
        nameLabel.text = detail.name
        nameLabel.textColor = detail.getColor()
        nameLabel.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        nameLabel.backgroundColor = UIColor.white
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont.chalet(fontSize: 18)
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.setContentHuggingPriority(.required, for: .vertical)
        imgView.addSubview(nameLabel)
        nameLabel.anchor(tagLabel.bottomAnchor, leading: imgView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10.0, left: 20.0, bottom: 0.0, right: 0.0), size: .init(0, 30.0))
        nameLabel.sizeToFit()
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = detail.shortDescription
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = UIFont.MontserratSemiBold(fontSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.setContentHuggingPriority(.required, for: .vertical)
        imgView.addSubview(descriptionLabel)
        descriptionLabel.anchor(nameLabel.bottomAnchor, leading: imgView.leadingAnchor, bottom: nil, trailing: imgView.trailingAnchor, padding: .init(top: 10.0, left: 20.0, bottom: 0, right: -20.0), size: .init(0, 60.0))
        descriptionLabel.sizeToFit()
        
        imgView.clipsToBounds = true
        
        imgView.anchor(infoView.topAnchor, leading: infoView.leadingAnchor, bottom: descriptionLabel.bottomAnchor, trailing: infoView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 10.0, right: 0))
        
        let dateImgView = UIImageView()
        dateImgView.image = UIImage.init(named: "ic-fechas")
        dateImgView.contentMode = .scaleAspectFit
        infoView.addSubview(dateImgView)
        dateImgView.anchor(imgView.bottomAnchor, leading: infoView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20.0, left: 20.0, bottom: 0.0, right: 0.0), size: .init(20, 20.0))
        
        let dateLabel = UILabel()
        
        let startAttr = [NSAttributedStringKey.font : UIFont.MontserratBold(fontSize: 14), NSAttributedStringKey.foregroundColor : UIColor.lightGray]
        
        let finishAttr = [NSAttributedStringKey.font : UIFont.MontserratBold(fontSize: 14), NSAttributedStringKey.foregroundColor : UIColor.lightGray]
        
        let startAttributed = NSMutableAttributedString(string:"Inicio: ", attributes:startAttr)
        
        let finishAttributed = NSMutableAttributedString(string:"Finalizado: ", attributes:finishAttr)
        
        let startDataAttr = [NSAttributedStringKey.font : UIFont.MontserratRegular(fontSize: 14), NSAttributedStringKey.foregroundColor : UIColor.lightGray]
        
        let finishDataAttr = [NSAttributedStringKey.font : UIFont.MontserratRegular(fontSize: 14), NSAttributedStringKey.foregroundColor : UIColor.lightGray]
        
        let startData = NSMutableAttributedString(string: "\(detail.started!) | ", attributes: startDataAttr)
        let endedData = NSMutableAttributedString(string: "\(detail.ended!)", attributes: finishDataAttr)
        
        startAttributed.append(startData)
        finishAttributed.append(endedData)
        
        startAttributed.append(finishAttributed)
        dateLabel.attributedText = startAttributed
        
        dateLabel.textColor = UIColor.lightGray
        dateLabel.textAlignment = .left
        infoView.addSubview(dateLabel)
        dateLabel.anchor(imgView.bottomAnchor, leading: dateImgView.trailingAnchor, bottom: nil, trailing: infoView.trailingAnchor, padding: .init(top: 20, left: 10, bottom: 0, right: 0) ,size: .init(0, 20.0))
        
        let montoImgView = UIImageView()
        montoImgView.image = UIImage.init(named: "ic-montos")
        montoImgView.contentMode = .scaleAspectFit
        infoView.addSubview(montoImgView)
        montoImgView.anchor(dateLabel.bottomAnchor, leading: infoView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 5.0, left: 20.0, bottom: 0.0, right: 0.0), size: .init(20, 20.0))
        
        let montoLabel = UILabel()
        
        let montaAttr = [NSAttributedStringKey.font : UIFont.MontserratBold(fontSize: 14), NSAttributedStringKey.foregroundColor : UIColor.lightGray]
        
        let amountAttr = [NSAttributedStringKey.font : UIFont.MontserratRegular(fontSize: 14), NSAttributedStringKey.foregroundColor : UIColor.lightGray]
        
        let montAttributed = NSMutableAttributedString(string:"Monto: ", attributes:montaAttr)
        
        let amountAttributed = NSMutableAttributedString(string:"$\(detail.amountStr!)", attributes:amountAttr)
        
        montAttributed.append(amountAttributed)
        montoLabel.attributedText = montAttributed
        
        montoLabel.textAlignment = .left
        infoView.addSubview(montoLabel)
        montoLabel.anchor(dateImgView.bottomAnchor, leading: montoImgView.trailingAnchor, bottom: nil, trailing: infoView.trailingAnchor, padding: .init(top: 5.0, left: 10, bottom: 0, right: 0) ,size: .init(0, 20.0))
        
        let line = UIView()
        line.backgroundColor = UIColor.lightGray
        infoView.addSubview(line)
        line.anchor(montoLabel.bottomAnchor, leading: infoView.leadingAnchor, bottom: nil, trailing: infoView.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 0, right: -20), size: .init(width: 0, height: 0.5))
        
        
        let neighborsLabel = UILabel()
        neighborsLabel.text = detail.neighbors
        neighborsLabel.textColor = detail.getColor()
        neighborsLabel.textAlignment = .left
        neighborsLabel.font = UIFont.chalet(fontSize: 30)
        infoView.addSubview(neighborsLabel)
        neighborsLabel.anchor(line.bottomAnchor, leading: infoView.leadingAnchor, bottom: nil, trailing: infoView.trailingAnchor, padding: .init(top: 30, left: 10, bottom: 0, right: 10) ,size: .init(width: 0, height: 30))
        
        let neighborsTextLabel = UILabel()
        neighborsTextLabel.text = detail.neighborsText
        neighborsTextLabel.textColor = UIColor.black
        neighborsTextLabel.textAlignment = .left
        neighborsTextLabel.font = UIFont.MontserratSemiBold(fontSize: 16)
        neighborsTextLabel.numberOfLines = 0
        neighborsTextLabel.adjustsFontSizeToFitWidth = true
        neighborsTextLabel.minimumScaleFactor = 0.5
        
        infoView.addSubview(neighborsTextLabel)
        neighborsTextLabel.anchor(neighborsLabel.bottomAnchor, leading: infoView.leadingAnchor, bottom: nil, trailing: infoView.trailingAnchor, padding: .init(top: -5, left: 10, bottom: 0, right: -10) ,size: .init(width: 0, height: 34))
        
        let m2Label = UILabel()
        m2Label.text = detail.m2
        m2Label.textColor = detail.getColor()
        m2Label.textAlignment = .left
        m2Label.font = UIFont.chalet(fontSize: 30)
        infoView.addSubview(m2Label)
        m2Label.anchor(neighborsTextLabel.bottomAnchor, leading: infoView.leadingAnchor, bottom: nil, trailing: infoView.trailingAnchor, padding: .init(top: 20, left: 10, bottom: 0, right: 10) ,size: .init(width: 0, height: 30))
        
        let m2LabelTextLabel = UILabel()
        m2LabelTextLabel.text = detail.m2Text
        m2LabelTextLabel.textColor = UIColor.black
        m2LabelTextLabel.textAlignment = .left
        m2LabelTextLabel.font = UIFont.MontserratSemiBold(fontSize: 16)
        m2LabelTextLabel.numberOfLines = 0
        infoView.addSubview(m2LabelTextLabel)
        m2LabelTextLabel.anchor(m2Label.bottomAnchor, leading: infoView.leadingAnchor, bottom: nil, trailing: infoView.trailingAnchor, padding: .init(top: -5, left: 10, bottom: 20, right: -10) ,size: .init(width: 0, height: 60))
        
        
        infoView.setCellShadow()
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(MapDetailViewController.infoViewPressed))
        infoView.addGestureRecognizer(tap)
        
        
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            // ******************* INFOSIZE *********************
            infoView.anchor(view.centerYAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: -150, left: 15, bottom: -15, right: -10), size: .init(400, 0))
        }
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            // ******************* INFOSIZE *********************
            infoView.anchor(view.centerYAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: -150, left: 15, bottom: -20, right: -15))
        }
        
        addDraggableGesture()
        
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
        
        // pageControlposition
        pageControl.currentPage = currentIndex
    
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
        
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = GeminiCell()
        
        if indexPath.item == 0
        {
            
            if UIDevice.current.userInterfaceIdiom == .pad {
            // Configure For Street Cell
                let cellStreet = collectionView.dequeueReusableCell(withReuseIdentifier: "StreetCollectionViewCell", for: indexPath) as! StreetCollectionSwipeViewCell
                cellStreet.state = detail.state
                cellStreet.imageArray = streetImageArray
                cell = cellStreet
            }
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                // Configure For Street Cell
                let cellStreet = collectionView.dequeueReusableCell(withReuseIdentifier: "StreetCollectionViewCell", for: indexPath) as! StreetCollectionViewCell
                
                cellStreet.state = detail.state
                cellStreet.imageArray = streetImageArray
                cell = cellStreet
            }
        }
        else
        {
            if UIDevice.current.userInterfaceIdiom == .pad{
            // Configure For Drone Cell
                let cellDrone = collectionView.dequeueReusableCell(withReuseIdentifier: "DroneCollectionViewCell", for: indexPath) as! DroneCollectionSwipeViewCell
                cellDrone.state = detail.state
                cellDrone.imageArray = droneImageArray
                cell = cellDrone
            }
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                let cellDrone = collectionView.dequeueReusableCell(withReuseIdentifier: "DroneCollectionViewCell", for: indexPath) as! DroneCollectionViewCell
                cellDrone.state = detail.state
                cellDrone.imageArray = droneImageArray
                cell = cellDrone
            }
            
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

extension MapDetailViewController: UIGestureRecognizerDelegate {
    
}



