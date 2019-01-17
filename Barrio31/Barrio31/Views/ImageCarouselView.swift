//
//  ImageCarouselView.swift
//  Barrio31
//
//  Created by Tomás Fernandez Nuñez on 16/01/2019.
//  Copyright © 2019 Carlos Garcia. All rights reserved.
//

import UIKit
import ImageSlideshow
import SDWebImage

protocol ImageCarouselInteractionDelegate {
    func imageWasTapped(imageSlideShow: ImageSlideshow)
}

class ImageCarouselView: UIView {
    
    static var preferredHeight = 400
    
    @IBOutlet var imageSlideShow: ImageSlideshow!
    
    var pageControl = UIPageControl()
    var imageSources: [SDWebImageSource] = [] {
        didSet {
            configureImageSlideShow()
        }
    }
    
    var delegate: ImageCarouselInteractionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureImageSlideShow()
    }
    
    private func configureImageSlideShow() {
        
        //imageSlideShow = ImageSlideshow()
        
        imageSlideShow.slideshowInterval = 5.0
        imageSlideShow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
        
        //imageSlideShow.backgroundColor = .white
        
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        
        imageSlideShow.pageIndicator = pageControl
        imageSlideShow.pageIndicatorPosition = PageIndicatorPosition()
        
        imageSlideShow.layoutPageControl()
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        imageSlideShow.activityIndicator = DefaultActivityIndicator()
        imageSlideShow.currentPageChanged = { page in
            print("current page:", page)
        }
        
        imageSlideShow.setImageInputs(imageSources)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTapImageSlider))
        imageSlideShow.addGestureRecognizer(recognizer)
    }
    
    @objc func didTapImageSlider() {
        delegate?.imageWasTapped(imageSlideShow: imageSlideShow)
    }
}
