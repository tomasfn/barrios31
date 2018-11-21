//
//  StreetCollectionViewCell.swift
//  Barrio31
//
//  Created by Tomás Fernandez Nuñez on 21/11/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import UIKit
import Gemini

class StreetCollectionViewCell: GeminiCell {
    
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
            }
        }
    }
    
    fileprivate var currentIndex = 0
    
    override func awakeFromNib() {
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
            
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(StreetCollectionViewCell.scrollViewTapped))
            scrollView.addGestureRecognizer(tap)
            
            scrollView.addSubview(imageView)
        }
        
        scrollView.fillSuperview()
        scrollView.backgroundColor = UIColor.white
        scrollView.contentMode = .scaleAspectFill
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
            
            scrollToPage(page: currentIndex, animated: true)
        }
    }
    
    func scrollToPage(page: Int, animated: Bool) {
        var frame: CGRect = self.scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        self.scrollView.scrollRectToVisible(frame, animated: animated)
    }
}

extension StreetCollectionViewCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}
