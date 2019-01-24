//
//  DisfrutaDetailViewController.swift
//  Barrio31
//
//  Created by air on 02/11/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import UIKit
import ImageSlideshow
import SDWebImage

class DisfrutaDetailViewController: BaseViewController {
    
    @IBOutlet weak var headerImgView: UIImageView!
    @IBOutlet weak var carouselImageView: ImageCarouselView!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    
    @IBOutlet weak var descriptionTxtView: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var datesLbl: UILabel!
    @IBOutlet weak var entryTypeLbl: UILabel!
    
    var item: DisfrutaDetail!

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavbarItems()
        setUpView()
    }
    
    func setUpView() {
        
        scrollView.delegate = self
        
            if #available(iOS 11.0, *) {
                scrollView.contentInsetAdjustmentBehavior = .never
            } else {
                // Fallback on earlier versions
            }
        
        if let imgLink = item.imageLink {
            let url = URL(string: imgLink)
            headerImgView.kf.setImage(with: url)
        }
        
        
        if item.imagesCarousel.count > 0 {
            var imageSources: [SDWebImageSource] = []
            
            for img in item.imagesCarousel {
                imageSources.append(SDWebImageSource(url: URL(string: img)!))
            }
            
            carouselImageView.delegate = self
            carouselImageView.imageSlideShow.setImageInputs(imageSources)
        }
        
        
        titleLbl.text = item.name
        subtitleLbl.text = item.shortDescription
        
        titleLbl.textColor = UIColor.hexStringToUIColor(hex: "#f9a61d")
        
        titleLbl.font = UIFont.chalet(fontSize: 25)
        subtitleLbl.font = UIFont.chalet(fontSize: 22)
        
        descriptionTxtView.text = item.longDescription
        descriptionTxtView.font = UIFont.MontserratSemiBold(fontSize: 16)
        
        let startAttr = [NSAttributedStringKey.font : UIFont.MontserratBold(fontSize: 14), NSAttributedStringKey.foregroundColor : UIColor.lightGray]
        
        let finishAttr = [NSAttributedStringKey.font : UIFont.MontserratBold(fontSize: 14), NSAttributedStringKey.foregroundColor : UIColor.lightGray]
        
        let startAttributed = NSMutableAttributedString(string:"Inicio: ", attributes:startAttr)
        
        let finishAttributed = NSMutableAttributedString(string:"Finaliza: ", attributes:finishAttr)
        
        let startDataAttr = [NSAttributedStringKey.font : UIFont.MontserratBold(fontSize: 14), NSAttributedStringKey.foregroundColor : UIColor.lightGray]
        
        let finishDataAttr = [NSAttributedStringKey.font : UIFont.MontserratBold(fontSize: 14), NSAttributedStringKey.foregroundColor : UIColor.lightGray]        
        
        let startData = NSMutableAttributedString(string: "\(item.started!) | ", attributes: startDataAttr)
        let endedData = NSMutableAttributedString(string: "\(item.ended!) \n \(item.schedule!)", attributes: finishDataAttr)
        
        startAttributed.append(startData)
        finishAttributed.append(endedData)
        
        startAttributed.append(finishAttributed)
        datesLbl.attributedText = startAttributed
        
        let priceDataAttr = [NSAttributedStringKey.font : UIFont.MontserratBold(fontSize: 14), NSAttributedStringKey.foregroundColor : UIColor.lightGray]
        let priceAttr = NSMutableAttributedString(string: "\(item.price!)", attributes: priceDataAttr)

        entryTypeLbl.attributedText = priceAttr
        
        descriptionTxtView.isScrollEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBarClear()
    }
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNavBarDefault()
        UIApplication.shared.statusBarView?.backgroundColor = .clear
    }
    
    override func viewDidLayoutSubviews() {
        adjustUITextViewHeight(arg: descriptionTxtView)
        //setScrollViewToFitContent()
    }
    
    func setScrollViewToFitContent() {
        var contentRect = CGRect.zero
        for view in scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        scrollView.contentSize = contentRect.size
    }
    
    override func viewDidAppear(_ animated: Bool) {
        descriptionTxtView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    func setNavBarClear() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setNavBarDefault() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .black
        navigationController?.view.backgroundColor = UIColor.white
    }
    
    func setNavbarItems() {
        
        let buttonRight = UIButton()
        buttonRight.setImage(UIImage.shareImage(), for: UIControlState.normal)
        buttonRight.addTarget(self, action:#selector(DisfrutaDetailViewController.shareItem), for:.touchUpInside)
        buttonRight.anchorCenterSuperview()
        buttonRight.widthAnchor.constraint(equalToConstant: 37.0)
        buttonRight.heightAnchor.constraint(equalToConstant: 37.0)
        let barRightButton = UIBarButtonItem.init(customView: buttonRight)
        self.navigationItem.rightBarButtonItem = barRightButton
        
        let buttonLeft = UIButton()
        buttonLeft.setImage(UIImage.cerrarImage(), for: UIControlState.normal)
        buttonLeft.contentMode = .scaleAspectFit
        buttonLeft.addTarget(self, action:#selector(DisfrutaDetailViewController.goBack), for:.touchUpInside)
        buttonLeft.anchorCenterSuperview()
        buttonLeft.widthAnchor.constraint(equalToConstant: 37.0)
        buttonLeft.heightAnchor.constraint(equalToConstant: 37.0)
        let barLeftButton = UIBarButtonItem.init(customView: buttonLeft)
        self.navigationItem.leftBarButtonItem = barLeftButton
    }
    
    @objc func goBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func shareItem() {
        //Set the default sharing message.
        
        var message = ""
        
        if let name = item.name, let schedule = item.schedule {
            message = "Vení a \(name) de \(schedule)"
        }
        
        //Set the link to share.
        if let link = NSURL(string: "http://barrio31.candoit.com.ar/")
        {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}

extension DisfrutaDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offset = scrollView.contentOffset.y / 150
        if offset > 1 {
            offset = 1
            
            let color = UIColor(red:0.92, green:0.92, blue:0.92, alpha:offset)
            self.navigationController?.navigationBar.tintColor = .lightGray
            self.navigationController?.navigationBar.backgroundColor = color
            UIApplication.shared.statusBarView?.backgroundColor = color
            self.navigationController?.navigationBar.layoutIfNeeded()
            
        } else {
            let color = UIColor(red:0.92, green:0.92, blue:0.92, alpha:offset)
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.backgroundColor = color
            UIApplication.shared.statusBarView?.backgroundColor = color
            self.navigationController?.navigationBar.layoutIfNeeded()
        }
        
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.isAtTop {
            if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
                print("down")
            } else {
               //goBack()
            }
        }
    }
}

//MARK: Configuring ImageCarouselView Presenter
extension DisfrutaDetailViewController: ImageCarouselInteractionDelegate {
    
    func imageWasTapped(imageSlideShow: ImageSlideshow) {
        let fullScreenController = imageSlideShow.presentFullScreenController(from:  self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
}
