//
//  NavigationHelper.swift
//  Barrio31
//
//  Created by Tomás Fernandez Nuñez on 28/11/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import UIKit

private let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

class NavigationHelper: NSObject {
    
    class func setRootViewController(_ viewController: UIViewController?, animated: Bool = true) {
        guard viewController != nil,
            let window = UIApplication.shared.delegate?.window else { return }
        
        if (animated == false || window!.rootViewController == nil) {
            
            window!.rootViewController = viewController
            
        } else {
            
            let snapshot = window!.snapshotView(afterScreenUpdates: true)
            viewController!.view.addSubview(snapshot!)
            
            window!.rootViewController = viewController
            UIView.animate(withDuration: 0.35, animations: { () -> Void in
                snapshot!.layer.opacity = 0
            }, completion: { (finished) -> Void in
                snapshot!.removeFromSuperview()
            })
        }
    }
}

//MARK: ViewControllers
extension NavigationHelper {
    
    class func mapViewController() -> MapViewController {
        return mainStoryboard.instantiateViewController(withIdentifier: MapViewController.nameOfClass) as! MapViewController
    }
    
}

//MARK: NavigationControllers
extension NavigationHelper {
    
//    fileprivate class func baseNavigationController() -> BaseNavigationController {
//        return mainStoryboard.instantiateViewController(withIdentifier: BaseNavigationController.nameOfClass) as! BaseNavigationController
//    }
}
