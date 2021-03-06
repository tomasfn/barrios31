//
//  StreetCollectionSwipeViewController.swift
//  Barrio31
//
//  Created by air on 10/01/2019.
//  Copyright © 2019 Carlos Garcia. All rights reserved.
//

import UIKit
import Foundation
import Gemini

@IBDesignable
public class StreetCollectionSwipeViewCell: GeminiCell {

    var image = MapDetailViewController()
    
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
    
//    ***** SLIDER! **** 
    
    @IBInspectable
    public var image1: UIImage = UIImage(){
        didSet {
            imageView1.image = image1
        }
    }
    
    fileprivate lazy var imageView1: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    @IBInspectable
    public var image2: UIImage = UIImage(){
        didSet {
         
            imageView2.image = image2
        }
    }
    
    fileprivate lazy var imageView2: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    fileprivate lazy var thumbWrapper: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        return v
    }()
    
    @IBInspectable
    public var thumbColor: UIColor = UIColor.blue{
        didSet {
            line.backgroundColor = thumbColor
        }
    }
    
    fileprivate lazy var line: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        return v
    }()
    
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
        return iv
    }()
    
    fileprivate lazy var image1Wrapper: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        return v
    }()
    
    
    lazy fileprivate var setupLeadingAndOriginRect: Void = {
        self.layoutIfNeeded()
        self.originRect = self.image1Wrapper.frame
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
    
    // *****************
    
    
    func setupImages(_ images: [UIImage]){

        for i in 0..<images.count {

            imageView1.image = images[0]
            imageView2.image = images[1]
            
            let xPosition = UIScreen.main.bounds.width * CGFloat()
            image1Wrapper.frame = CGRect(x: xPosition, y: 0, width: self.frame.width, height: self.frame.height)
        
//            imageView1.frame = CGRect(x: xPosition, y: 0, width: image1Wrapper.frame.width, height: image1Wrapper.frame.height)
//
//            imageView2.frame = CGRect(x: xPosition, y: 0, width: image1Wrapper.frame.width, height: image1Wrapper.frame.height)

        }

        scrollView.fillSuperview()
        scrollView.delegate = self
        scrollView.resizeScrollViewContentSize()
        addSubview(imageView1)
        image1Wrapper.addSubview(imageView2)
        addSubview(image1Wrapper)
        addSubview(thumbWrapper)
        
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

extension StreetCollectionSwipeViewCell: UIScrollViewDelegate {
    
    private func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    private func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
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


extension StreetCollectionSwipeViewCell {
    fileprivate func initialize() {

        
        scrollView.addSubview(image1Wrapper)
        image1Wrapper.addSubview(imageView1)

        addSubview(imageView2)
        addSubview(scrollView)

        thumbWrapper.addSubview(setIndicatorImage())
        thumbWrapper.addSubview(line)
        addSubview(thumbWrapper)

        
        NSLayoutConstraint.activate([
            imageView2.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            imageView2.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            imageView2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            imageView2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)

            ])


        leading = image1Wrapper.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            image1Wrapper.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            image1Wrapper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            image1Wrapper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            leading
            ])
        
        NSLayoutConstraint.activate([
            imageView1.topAnchor.constraint(equalTo: image1Wrapper.topAnchor, constant: 0),
            imageView1.bottomAnchor.constraint(equalTo: image1Wrapper.bottomAnchor, constant: 0),
            imageView1.trailingAnchor.constraint(equalTo: image1Wrapper.trailingAnchor, constant: 0),
            imageView1.leadingAnchor.constraint(equalTo: image1Wrapper.leadingAnchor, constant: 0)
            ])
        
        
        NSLayoutConstraint.activate([
            thumbWrapper.topAnchor.constraint(equalTo: image1Wrapper.topAnchor, constant: 0),
            thumbWrapper.bottomAnchor.constraint(equalTo: image1Wrapper.bottomAnchor, constant: 0),
            thumbWrapper.leadingAnchor.constraint(equalTo: image1Wrapper.leadingAnchor, constant: -35),
            thumbWrapper.widthAnchor.constraint(equalToConstant: 65)
            ])
        
        
        NSLayoutConstraint.activate([
            thumbImage.centerXAnchor.constraint(equalTo: thumbWrapper.centerXAnchor, constant: 0),
            thumbImage.centerYAnchor.constraint(equalTo: thumbWrapper.centerYAnchor, constant: 0),
            thumbImage.widthAnchor.constraint(equalTo: thumbWrapper.widthAnchor, constant: 0),
            thumbImage.heightAnchor.constraint(equalTo: thumbWrapper.widthAnchor, constant: 0)
            ])
        
        NSLayoutConstraint.activate([
            line.centerXAnchor.constraint(equalTo: thumbWrapper.centerXAnchor, constant: 0),
            line.centerYAnchor.constraint(equalTo: thumbWrapper.centerYAnchor, constant: 0),
            line.widthAnchor.constraint(equalTo: thumbWrapper.widthAnchor, multiplier: 0.1),
            line.heightAnchor.constraint(equalTo: thumbWrapper.widthAnchor, multiplier: 30)
            ])
        

        leading.constant = frame.width / 1.1
        
        imageView1.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        imageView1.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1).isActive = true

        let tap = UIPanGestureRecognizer(target: self, action: #selector(gesture(sender:)))
        thumbWrapper.isUserInteractionEnabled = true
        thumbWrapper.addGestureRecognizer(tap)

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
            originRect = image1Wrapper.frame
        default: break
        }
    }
}





