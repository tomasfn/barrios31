//
//  GSSimpleImageView.swift
//  GSSimpleImage
//
//  Created by 胡秋实 on 16/1/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//


import UIKit

class GSSimpleImageView: UIImageView {
    
    var bgView: UIView!
    
    var animated: Bool = true
    
    //MARK: Life cycle
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTapGesture()
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private methods
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: Selector(("fullScreenMe")))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    //MARK: Actions of Gestures
    func exitFullScreen () {
        bgView.removeFromSuperview()
    }
    
    func fullScreenMe() {
        
        if let window = UIApplication.shared.delegate?.window {
            bgView = UIView(frame: UIScreen.main.bounds)
            bgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector(("exitFullScreen"))))
            bgView.backgroundColor = UIColor.black
            let imageV = UIImageView(image: self.image)
            imageV.frame = bgView.frame
            imageV.contentMode = .scaleAspectFit
            self.bgView.addSubview(imageV)
            window?.addSubview(bgView)
            
            if animated {
                var sx:CGFloat=0, sy:CGFloat=0
                if self.frame.size.width > self.frame.size.height {
                    sx = self.frame.size.width/imageV.frame.size.width
                    imageV.transform = CGAffineTransform(scaleX: sx, y: sx)
                }else{
                    sy = self.frame.size.height/imageV.frame.size.height
                    imageV.transform = CGAffineTransform(scaleX: sy, y: sy)
                }
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    imageV.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
            }
        }
    }
    
}
