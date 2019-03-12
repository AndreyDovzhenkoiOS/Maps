//
//  Extension+RegisterCell.swift
//  Map
//
//  Created by Andrey on 02.08.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import UIKit

extension UITableView {
    public func registerCell(_ identifier: String) {
        register(UINib(nibName: identifier, bundle: nil),
                 forCellReuseIdentifier: identifier)
    }
}
