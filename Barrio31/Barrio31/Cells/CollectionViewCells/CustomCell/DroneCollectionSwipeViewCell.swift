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
    fileprivate var trailing: NSLayoutConstraint!
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
                setIndicatorImage()
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
    
    @IBInspectable
    public var thumbIm: UIImage = UIImage(){
        didSet {
            
            thumbImage.image = thumbIm
            
        }
    }
    fileprivate lazy var thumbImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        //iv.clipsToBounds = true
        return iv
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
    
    // ************
    
    func setIndicatorImage()->UIImageView{
        if state == "FUTURE" {
            thumbImage.image = UIImage(named: "ic-ayer-manana")
        }else{
            thumbImage.image = UIImage(named: "ic-ayer-hoy")
        }
        return thumbImage
    }
    
    // ************
    
    func setupImages(_ images: [UIImage]){
        
        for i in 0..<images.count {
            
            imageView3.image = images[0]
            imageView4.image = images[1]
            
            let xPosition = UIScreen.main.bounds.width * CGFloat()
            image2Wrapper.frame = CGRect(x: xPosition, y: 0, width: self.frame.width, height: self.frame.height)
            
//            imageView3.frame = CGRect(x: xPosition, y: 0, width: image2Wrapper.frame.width, height: image2Wrapper.frame.height)
//            
//            imageView4.frame = CGRect(x: xPosition, y: 0, width: image2Wrapper.frame.width, height: image2Wrapper.frame.height)
        }
        
        scrollView.fillSuperview()
        scrollView.delegate = self
        scrollView.resizeScrollViewContentSize()
        addSubview(imageView3)
        image2Wrapper.addSubview(imageView4)
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
        
        addSubview(imageView4)
        addSubview(scrollView)
        
        thumbWrapper2.addSubview(setIndicatorImage())
        thumbWrapper2.addSubview(line)
        addSubview(thumbWrapper2)
        
        
        NSLayoutConstraint.activate([
            imageView4.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imageView4.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            imageView4.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            imageView4.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
            
            ])
        
        
        leading = image2Wrapper.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        trailing = image2Wrapper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            image2Wrapper.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            image2Wrapper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            trailing,
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
            thumbWrapper2.leadingAnchor.constraint(equalTo: image2Wrapper.leadingAnchor, constant: -35),
            thumbWrapper2.widthAnchor.constraint(equalToConstant: 65)
            ])
        
        NSLayoutConstraint.activate([
            line.centerXAnchor.constraint(equalTo: thumbWrapper2.centerXAnchor, constant: 0),
            line.centerYAnchor.constraint(equalTo: thumbWrapper2.centerYAnchor, constant: 0),
            line.widthAnchor.constraint(equalTo: thumbWrapper2.widthAnchor, multiplier: 0.1),
            line.heightAnchor.constraint(equalTo: thumbWrapper2.widthAnchor, multiplier: 40)
            ])
        
        NSLayoutConstraint.activate([
            thumbImage.centerXAnchor.constraint(equalTo: thumbWrapper2.centerXAnchor, constant: 0),
            thumbImage.centerYAnchor.constraint(equalTo: thumbWrapper2.centerYAnchor, constant: 0),
            thumbImage.widthAnchor.constraint(equalTo: thumbWrapper2.widthAnchor, constant: 0),
            thumbImage.heightAnchor.constraint(equalTo: thumbWrapper2.widthAnchor, constant: 0)
            ])
    
        
        leading.constant = frame.width / 1.1
        
        imageView3.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        imageView3.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1).isActive = true
        
        let tap = UIPanGestureRecognizer(target: self, action: #selector(gesture(sender:)))
        thumbWrapper2.isUserInteractionEnabled = true
        thumbWrapper2.addGestureRecognizer(tap)
    }
    
    
    @objc func gesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        switch sender.state {
        case .began, .changed:
            var newLeading = originRect.origin.x + translation.x
            newLeading = max(newLeading, 50)
            newLeading = min(frame.width - 50, newLeading)
            leading.constant = newLeading
            layoutIfNeeded()
        case .ended, .cancelled:
            originRect = image2Wrapper.frame
        default: break
        }
    }
}
