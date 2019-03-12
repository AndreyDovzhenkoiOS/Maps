//
//  Extension+ViewController.swift
//  Map
//
//  Created by Andrey on 02.08.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import UIKit

extension UIViewController {
    static var storyboardName: String {
        let storyboardName = identifier as NSString
        let range = storyboardName.range(of: Constants.viewController)
        return storyboardName.substring(to: range.location)
    }
    
    public func getViewcntroller(_ storyboardName: String, _ identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        return viewController
    }
}

