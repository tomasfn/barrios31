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

class MapDetailViewController: BaseViewController {
  
  var detail : PolygonDetail!
  var imgView: UIImageView!
  var bottomView : UIView!
  var pageControl : UIPageControl!
  var ayerLabel : UILabel!
  var hoyLabel : UILabel!
  var mañanaLabel : UILabel!
  var infoButton : UIButton!
  var videoButton : UIButton!
  var infoView : UIView!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    imgView = UIImageView()
    self.view.addSubview(imgView)
    imgView.fillSuperview()
    imgView.backgroundColor = UIColor.white
    if let street = detail.street {
      if let before = street["beforeLink"] {
        let url = "http://barrio31.candoit.com.ar" + before
        SVProgressHUD.show()
        Alamofire.request(url).responseImage { [weak self] response in
          SVProgressHUD.dismiss()
          if let image = response.result.value {
            self!.imgView.image = image
          }
        }
      }
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
    
    pageControl = UIPageControl()
    self.view.addSubview(pageControl)
    if #available(iOS 11.0, *) {
      pageControl.anchor(view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor , size : .init(0, 40))
    } else {
      // Fallback on earlier versions
      pageControl.anchor(view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor , size : .init(0, 40))
    }
    pageControl.currentPage = 2
    pageControl.numberOfPages = 3
    pageControl.pageIndicatorTintColor = UIColor.white
    
    ayerLabel = UILabel()
    ayerLabel.text = "AYER"
    ayerLabel.textColor = UIColor.white
    ayerLabel.textAlignment = .center
    ayerLabel.font = UIFont.chalet(fontSize: 16)
    self.view.addSubview(ayerLabel)

    ayerLabel.anchor(pageControl.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, size : .init(view.width/3, 30))
    
    hoyLabel = UILabel()
    hoyLabel.text = "HOY"
    hoyLabel.textColor = UIColor.white
    hoyLabel.textAlignment = .center
    hoyLabel.font = UIFont.chalet(fontSize: 16)
    self.view.addSubview(hoyLabel)
    hoyLabel.anchor(pageControl.bottomAnchor, leading: ayerLabel.trailingAnchor, bottom: nil, trailing: nil, size : .init(view.width/3, 30))
    
    mañanaLabel = UILabel()
    mañanaLabel.text = "MAÑANA"
    mañanaLabel.textColor = UIColor.white
    mañanaLabel.textAlignment = .center
    mañanaLabel.font = UIFont.chalet(fontSize: 16)
    self.view.addSubview(mañanaLabel)
    mañanaLabel.anchor(pageControl.bottomAnchor, leading: hoyLabel.trailingAnchor, bottom: nil, trailing: nil, size : .init(view.width/3, 30))
  }
  
  @objc func videoPressed() {
    if let videoURL =  detail.videoUrl {
      let url = URL(string:videoURL)
      let player = AVPlayer(url: url!)
      let playerViewController = AVPlayerViewController()
      playerViewController.player = player
      self.present(playerViewController, animated: true) {
        playerViewController.player!.play()
      
      }
    }
    else {
      SVProgressHUD.showError(withStatus: "No hay video disponible")
    }
  }
  
  @objc func infoPressed() {
    if infoView == nil {
      createInfoView()
    }else {
      UIView.animate(withDuration: 0.5) {
        self.infoView.alpha = 1.0
      }
    }
  }
  
  @objc func infoViewPressed() {
    UIView.animate(withDuration: 0.5) {
      self.infoView.alpha = 0.0
    }
  }

  
  
  func createInfoView() {
    infoView = UIView()
    self.view.addSubview(infoView)
    infoView.backgroundColor = UIColor.white
    infoView.anchor(view.centerYAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 10.0, bottom: -10.0, right: -10.0))
    
    let imgView = UIImageView()
    imgView.image = #imageLiteral(resourceName: "pattern-alto-parque")
    imgView.contentMode = .scaleAspectFill
    infoView.addSubview(imgView)
    
    let tagLabel = UILabel()
    tagLabel.text = detail.categoryName
    tagLabel.textColor = UIColor.white
    tagLabel.textAlignment = .left
    //tagLabel.font = UIFont.chalet(fontSize: 16)
    imgView.addSubview(tagLabel)
    tagLabel.anchor(imgView.topAnchor, leading: imgView.leadingAnchor, bottom: nil, trailing: imgView.trailingAnchor, padding: .init(top: 10.0, left: 20.0, bottom: 0.0, right: -20.0), size: .init(0, 18.0))
    
    let nameLabel = UILabel()
    nameLabel.text = detail.name
    nameLabel.textColor = detail.getColor()
    nameLabel.backgroundColor = UIColor.white
    nameLabel.textAlignment = .left
    nameLabel.font = UIFont.chalet(fontSize: 18)
    nameLabel.numberOfLines = 0
    nameLabel.lineBreakMode = .byWordWrapping
    nameLabel.setContentHuggingPriority(.required, for: .vertical)
    imgView.addSubview(nameLabel)
    nameLabel.anchor(tagLabel.bottomAnchor, leading: imgView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 10.0, left: 20.0, bottom: 0.0, right: 0.0), size: .init(0, 18.0))
    nameLabel.sizeToFit()
    
    let descriptionLabel = UILabel()
    descriptionLabel.text = detail.shortDescription
    descriptionLabel.textColor = UIColor.white
    descriptionLabel.textAlignment = .left
    descriptionLabel.font = UIFont.chalet(fontSize: 16)
    descriptionLabel.numberOfLines = 0
    descriptionLabel.lineBreakMode = .byWordWrapping
    descriptionLabel.setContentHuggingPriority(.required, for: .vertical)
    imgView.addSubview(descriptionLabel)
    descriptionLabel.anchor(nameLabel.bottomAnchor, leading: imgView.leadingAnchor, bottom: nil, trailing: imgView.trailingAnchor, padding: .init(top: 10.0, left: 20.0, bottom: 0, right: -20.0))
    descriptionLabel.sizeToFit()
    
    imgView.clipsToBounds = true
    imgView.anchor(infoView.topAnchor, leading: infoView.leadingAnchor, bottom: descriptionLabel.bottomAnchor, trailing: infoView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 10.0, right: 0))
    infoView.setCellShadow()
    let tap = UITapGestureRecognizer.init(target: self, action: #selector(MapDetailViewController.infoViewPressed))
    infoView.addGestureRecognizer(tap)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
