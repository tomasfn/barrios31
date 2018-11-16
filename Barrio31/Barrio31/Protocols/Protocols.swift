//
//  Protocols.swift
//  Barrio31
//
//  Created by Tomás Fernandez Nuñez on 16/11/2018.
//  Copyright © 2018 Carlos Garcia. All rights reserved.
//

import UIKit

public protocol ArrayInstanciable {
    associatedtype InstanceType
    static func instancesFromJSONArray(jsonArray: [[String : AnyObject]]) -> [InstanceType]?
}


// EXTENSIONS

@objc public protocol Reusable {
    static var identifier: String! { get }
    @objc optional static var nib: UINib! { get }
}

public protocol CellHeight {
    static var cellHeight: CGFloat { get }
}

public protocol PopUpPresentable: class {
    func popUp(animated: Bool) -> Self
    func remove(animated: Bool)
}

public protocol JSONInstanciable {
    init(JSON: [String : AnyObject])
}


public protocol StandaloneCopiable {
    associatedtype InstanceType
    func standaloneCopy() -> InstanceType!
}
