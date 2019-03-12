//
//  LocationSearchViewController.swift
//  Map
//
//  Created by Andrey on 02.08.2018.
//  Copyright © 2018 Andrey Dovzhenko. All rights reserved.
//

import UIKit
import MapKit

protocol MapSearchDelegate: class{
    func pinZoom(placemark: MKPlacemark, select: Bool)
}

final class LocationSearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var mapView: MKMapView!
    weak var delegate: MapSearchDelegate?
    let viewModel = LocationSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSetting()
    }
    
    //MARK: - Functions
    
    public func defaultSetting() {
        settingTableView()
        viewModelCompletionHandle()
    }
    
    private func settingTableView() {
        tableView.rowHeight = tableView.frame.height / 11
        tableView.registerCell(LocationSearchTableViewCell.identifier)
    }
    
    private func selectPlacemark(_ placemark: MKPlacemark) {
        delegate?.pinZoom(placemark: placemark, select: viewModel.isSearchPlacemark)
        viewModel.isSearchPlacemark = !viewModel.isSearchPlacemark
    }
    
    private func viewModelCompletionHandle() {
        viewModel.completionHandlerSearch = {
            self.tableView.reloadData()
            self.viewModel.mapItems.forEach {
                self.delegate?.pinZoom(placemark: $0.placemark, select: false)
            }
        }
    }
    
    private func selectCell(_ indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.animateSelect {
            let placeMark = self.viewModel.mapItems[indexPath.section].placemark
            self.selectPlacemark(placeMark)
            self.dismiss(animated: true, completion: nil)
        }
        AudioPlayerManager.shared.setSound(Constants.Sounds.SoundNames.select,
                                           Constants.Sounds.Types.mp3,
                                           false)
    }
}

//MARK: - TableView

extension LocationSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.mapItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationSearchTableViewCell.identifier,
                                                 for: indexPath) as? LocationSearchTableViewCell
        cell?.mapItem = viewModel.mapItems[indexPath.section]
        return cell!
    }
    
    //MARK: - Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectCell(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.height * 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}

//MARK: - SearchResultsUpdating

extension LocationSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBarText = searchController.searchBar.text
        viewModel.updateSearchResult(searchBarText!, mapView.region)
        viewModel.isSearchPlacemark = !viewModel.isSearchPlacemark
    }
}
