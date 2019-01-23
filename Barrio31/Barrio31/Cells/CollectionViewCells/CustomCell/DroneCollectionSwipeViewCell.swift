//
//  DroneCollectionSwipeViewCell.swift
//  Barrio31
//
//  Created by air on 10/01/2019.
//  Copyright © 2019 Carlos Garcia. All rights reserved.
//

import UIKit
import Foundation
import Gemini

@IBDesignable
class DroneCollectionSwipeViewCell: GeminiCell {
    
    fileprivate var leading: NSLayoutConstraint!
    fileprivate var originRect: CGRect!
    
    
    var pageControl : UIPageControl!
    var ayerLabel : UILabel!
    var hoyLabel : UILabel!
    var mañanaLabel : UILabel!
    var state: String?
    var pageCounter: Int! = 2
    var currentIndex = 0
    
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = false
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.isScrollEnabled = false
        scroll.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        return scroll
    }()
        
    var imageArray = [UIImage]() {
        didSet {
            if imageArray.count > 1 {
                setupImages(imageArray)
                setIndicatorLbls()
            }
        }
    }
    
    ////// ************    slider    ***********
    
    @IBInspectable
    public var image3: UIImage = UIImage(){
        didSet {
            imageView3.image = image3
        }
    }
    
    fileprivate lazy var imageView3: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    @IBInspectable
    public var image4: UIImage = UIImage(){
        didSet {
            imageView4.image = image4
        }
    }
    
    fileprivate lazy var imageView4: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    fileprivate lazy var thumbWrapper2: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        return v
    }()
    
    @IBInspectable
    public var thumbColor: UIColor = UIColor.blue{
        didSet {
            thumb.backgroundColor = thumbColor
        }
    }
    
    fileprivate lazy var thumb: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        return v
    }()
    
    fileprivate lazy var line: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        return v
    }()
    
    fileprivate lazy var image2Wrapper: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        return v
    }()
    
    lazy fileprivate var setupLeadingAndOriginRect: Void = {
        //self.leading.constant = self.frame.width / 1.1
        self.layoutIfNeeded()
        self.originRect = self.image2Wrapper.frame
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        _ = setupLeadingAndOriginRect
    }
    
    ///////
    
    
    func setIndicatorLbls() {
        
        pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = pageCounter
        pageControl.currentPage = 0
        
        addSubview(pageControl)
        if #available(iOS 11.0, *) {
            pageControl.anchor(safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor , size : .init(0, 40))
        } else {
            // Fallback on earlier versions
            pageControl.anchor(topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor , size : .init(0, 40))
        }
        
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.isHidden = true
        
        ayerLabel = UILabel()
        ayerLabel.text = "AYER"
        ayerLabel.textColor = UIColor.white
        ayerLabel.textAlignment = .center
        ayerLabel.font = UIFont.chalet(fontSize: 16)
        addSubview(ayerLabel)
        
        ayerLabel.anchor(pageControl.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, size : .init(width/3, 30))
        
        mañanaLabel = UILabel()
        //Setting the current state of Item
        if state == "FUTURE" {
            mañanaLabel.text = "MAÑANA"
        } else {
            mañanaLabel.text = "HOY"
        }
        
        mañanaLabel.alpha = 0.5
        mañanaLabel.textColor = UIColor.white
        mañanaLabel.textAlignment = .center
        mañanaLabel.font = UIFont.chalet(fontSize: 16)
        addSubview(mañanaLabel)
        mañanaLabel.anchor(pageControl.bottomAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, size : .init(width/3, 30))
    }
    
    func setupImages(_ images: [UIImage]){
        
        for i in 0..<images.count {
            let imageView = UIImageView()
            imageView.image = images[i]
            let xPosition = UIScreen.main.bounds.width * CGFloat(i)
            imageView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            imageView3 = imageView
            imageView4 = imageView
            
            
            scrollView.addSubview(imageView4)
            
        }
        

        scrollView.fillSuperview()
        scrollView.backgroundColor = UIColor.black
        scrollView.delegate = self
        
        scrollView.addSubview(image2Wrapper)
        image2Wrapper.addSubview(imageView3)
        addSubview(image2Wrapper)
        addSubview(thumbWrapper2)
        
        
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

extension DroneCollectionSwipeViewCell: UIScrollViewDelegate {
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
            
        }
}

extension DroneCollectionSwipeViewCell {
    fileprivate func initialize() {
        
        
        scrollView.addSubview(image2Wrapper)
        image2Wrapper.addSubview(imageView3)
        
        scrollView.addSubview(thumbWrapper2)
        
        addSubview(scrollView)
        addSubview(imageView4)
        addSubview(image2Wrapper)
        
        thumbWrapper2.addSubview(line)
        thumbWrapper2.addSubview(thumb)
        addSubview(thumbWrapper2)
        
        
        NSLayoutConstraint.activate([
            imageView4.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imageView4.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            imageView4.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            imageView4.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
            
            ])
        
        
        leading = image2Wrapper.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            image2Wrapper.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            image2Wrapper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            image2Wrapper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            leading
            ])
        
        NSLayoutConstraint.activate([
            imageView3.topAnchor.constraint(equalTo: image2Wrapper.topAnchor, constant: 0),
            imageView3.bottomAnchor.constraint(equalTo: image2Wrapper.bottomAnchor, constant: 0),
            imageView3.trailingAnchor.constraint(equalTo: image2Wrapper.trailingAnchor, constant: 0)
            ])
        
        
        NSLayoutConstraint.activate([
            thumbWrapper2.topAnchor.constraint(equalTo: image2Wrapper.topAnchor, constant: 0),
            thumbWrapper2.bottomAnchor.constraint(equalTo: image2Wrapper.bottomAnchor, constant: 0),
            thumbWrapper2.leadingAnchor.constraint(equalTo: image2Wrapper.leadingAnchor, constant: -20),
            thumbWrapper2.widthAnchor.constraint(equalToConstant: 40)
            ])
        
        NSLayoutConstraint.activate([
            line.centerXAnchor.constraint(equalTo: thumbWrapper2.centerXAnchor, constant: 0),
            line.centerYAnchor.constraint(equalTo: thumbWrapper2.centerYAnchor, constant: 0),
            line.widthAnchor.constraint(equalTo: thumbWrapper2.widthAnchor, multiplier: 0.2),
            line.heightAnchor.constraint(equalTo: thumbWrapper2.widthAnchor, multiplier: 50)
            ])
        
        
        NSLayoutConstraint.activate([
            thumb.centerXAnchor.constraint(equalTo: thumbWrapper2.centerXAnchor, constant: 0),
            thumb.centerYAnchor.constraint(equalTo: thumbWrapper2.centerYAnchor, constant: 0),
            thumb.widthAnchor.constraint(equalTo: thumbWrapper2.widthAnchor, multiplier: 1),
            thumb.heightAnchor.constraint(equalTo: thumbWrapper2.widthAnchor, multiplier: 1)
            ])
        
        leading.constant = frame.width / 1.1
        
        
        thumb.layer.cornerRadius = 20
        
        imageView3.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        let tap = UIPanGestureRecognizer(target: self, action: #selector(gesture(sender:)))
        thumbWrapper2.isUserInteractionEnabled = true
        thumbWrapper2.addGestureRecognizer(tap)
    }
    
    
    @objc func gesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        switch sender.state {
        case .began, .changed:
            var newLeading = originRect.origin.x + translation.x
            newLeading = max(newLeading, 20)
            newLeading = min(frame.width - 20, newLeading)
            leading.constant = newLeading
            layoutIfNeeded()
        case .ended, .cancelled:
            originRect = image2Wrapper.frame
        default: break
        }
    }
}



