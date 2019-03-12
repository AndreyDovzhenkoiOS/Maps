//
//  MainViewController.swift
//  Map
//
//  Created by Andrey on 02.08.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import UIKit
import MapKit

final class MainViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationButton: UIButton!
    
    let viewModel = MainViewModel()
    let locationManager = CLLocationManager()
    var resultSearchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSetting()
    }
    
    override func viewDidLayoutSubviews() {
         locationButton.layer.cornerRadius = locationButton.frame.height / 2
    }
    
    //MARK: - Action
    
    @IBAction func currentLocationAction(_ sender: UIButton) {
        viewModel.zoomLocation(Constants.coordinateSpanZoom,
                               viewModel.userLocation)
    }
    
    @objc func directionAction(_ sender: UIButton) {
        viewModel.direction()
    }
    
    //MARK: - Functions
    
    public func defaultSetting() {
        settingLocationManager()
        setupLocationSearchTableViewController()
        viewModelCompletionHandle()
    }
    
    public func viewModelCompletionHandle() {
        viewModel.completionHandler = {[weak self] region in
            self?.mapView.setRegion(region, animated: true)
        }
    }
    
    public func settingLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    public func setupLocationSearchTableViewController() {
        let locationSearchViewController = getViewcntroller(LocationSearchViewController.storyboardName,
                                                            LocationSearchViewController.identifier)
            as! LocationSearchViewController
        locationSearchViewController.mapView = mapView
        locationSearchViewController.delegate = self
        resultSearchController = UISearchController(searchResultsController: locationSearchViewController)
        resultSearchController.searchResultsUpdater = locationSearchViewController
        settingAppearanceSearchController()
        setupSearchBar()
    }
    
    private func settingAppearanceSearchController() {
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
    
    private func setupSearchBar() {
        let searchBar = resultSearchController.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = Constants.searchBarPlaceholder
        searchBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6837923729)
        searchBar.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        searchBar.searchBarStyle = .prominent
        navigationItem.titleView = searchBar
    }
}

//MARK: - LocationManagerDelegate

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            viewModel.userLocation = location
            viewModel.zoomLocation(Constants.coordinateSpanZoom, location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

//MARK: - MapSearchDelegate

extension MainViewController: MapSearchDelegate {
    func pinZoom(placemark: MKPlacemark, select: Bool) {
        let cordinateSpan = select ? Constants.coordinateSpanZoom : Constants.coordinateSpanPin
        viewModel.selectedPlacemark = placemark
        if select {mapView.removeAnnotations(mapView.annotations)}   
        mapView.addAnnotation(viewModel.getAnnotation(placemark))
        viewModel.zoomLocation(cordinateSpan,placemark.location!)
    }
}

//MARK: - MapViewDelegate

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {return nil}
        let pinView = getPinView(annotation)
        let directionButton = getDirectionButton((pinView?.frame)!)
        pinView?.leftCalloutAccessoryView = directionButton
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.mapView.setRegion(mapView.region, animated: true)
    }
    
    private func getPinView(_ annotation: MKAnnotation) -> MKPinAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.pinViewId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Constants.pinViewId)
        pinView?.pinTintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        pinView?.canShowCallout = true
        return pinView
    }
    
    private func getDirectionButton(_ frame: CGRect) -> UIButton {
        let size = CGSize(width: frame.width / 1.06, height: frame.height / 1.3)
        let directionButton = UIButton(frame: CGRect(origin: .zero, size: size))
        directionButton.setImage(#imageLiteral(resourceName: "car"), for: .normal)
        directionButton.addTarget(self, action: #selector(directionAction(_:)), for: .touchUpInside)
        return directionButton
    }
}
