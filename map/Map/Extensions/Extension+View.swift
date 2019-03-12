//
//  Extension+View.swift
//  Map
//
//  Created by Andrey on 03.08.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import UIKit

public extension UIView {
    public func animateSelect(completion: @escaping() -> ()) {
        let duration = 0.2
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.alpha = 0.3
        }) { _ in
            UIView.animate(withDuration: duration, animations: {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.alpha = 1
            }) { _ in completion()}
        }
    }
}
