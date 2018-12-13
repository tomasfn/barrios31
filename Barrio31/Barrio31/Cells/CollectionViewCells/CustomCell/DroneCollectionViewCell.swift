//
//  DroneCollectionViewCell.swift
//  Barrio31
//
//  Created by Tomás Fernandez Nuñez on 21/11/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import UIKit
import Gemini


class DroneCollectionViewCell: GeminiCell {
    
    var pageControl : UIPageControl!
    var ayerLabel : UILabel!
    var hoyLabel : UILabel!
    var mañanaLabel : UILabel!
    var state: String?
    
    var pageCounter: Int! = 2
    var currentIndex = 0
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
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
    
    override func awakeFromNib() {
    }
    
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
            imageView.frame = CGRect(x: xPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(DroneCollectionViewCell.scrollViewTapped))
            scrollView.addGestureRecognizer(tap)
            
            scrollView.addSubview(imageView)
        }
        
        scrollView.fillSuperview()
        scrollView.backgroundColor = UIColor.white
        scrollView.contentMode = .scaleAspectFill
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView.delegate = self
        scrollView.resizeScrollViewContentSize()
        addSubview(scrollView)
    }
    
    @objc func scrollViewTapped(_ sender: UITapGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.recognized
        {
            print(sender.location(in: sender.view))

            if currentIndex == 0 {
                currentIndex = 1
            } else if currentIndex == 1 {
                currentIndex = 0
            }

            setLabelAlpha()
            
            // harcoding pageControlposition
            pageControl.currentPage = 1
            
            scrollToPage(page: currentIndex, animated: false)
        }
    }
    
    func scrollToPage(page: Int, animated: Bool) {
        var frame: CGRect = self.scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            self.scrollView.scrollRectToVisible(frame, animated: animated)
        })
        
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

extension DroneCollectionViewCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Change the page indicator
        
//        if pageCounter > 1 {
//            if currentIndex == 0 {
//                currentIndex = 1
//            } else if currentIndex == 1 {
//                currentIndex = 0
//            }
//        }
        
    }
}
