//
//  LocationSearchTableViewCell.swift
//  Map
//
//  Created by Andrey on 02.08.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import UIKit
import MapKit

final class LocationSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var datailLabel: UILabel!
    
    var mapItem: MKMapItem! {
        didSet {updateUI()}
    }
    
    private func updateUI() {
        let placemark = mapItem.placemark
        nameLabel.text = placemark.name
        datailLabel.text = placemark.fullAdress
        layer.cornerRadius = frame.height / 8
    }
}
