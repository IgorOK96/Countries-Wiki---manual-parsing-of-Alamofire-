//
//  ViewController.swift
//  Countries wiki
//
//  Created by user246073 on 9/29/24.
//

import UIKit
import Alamofire

final class MainViewController: UITableViewController {
    
    // MARK: - Properties
    private let networkManager = NetworkManager.shared
    private var countries: [Country] = []
    private var filteredCountries: [Country] = []
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return true }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 105
        fetchCountry()
        setupSearchController()
    }
    
    // MARK: - Data Fetching
    private func fetchCountry() {
        networkManager.fetchCountries(from: Link.countryURL.url) { [unowned self] result in
            switch result {
            case .success(let contries):
                self.countries = contries
                tableView.reloadData()
            case .failure(let error):
                showAlert(withTitle: "Opps", andMessage: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Search Functionality
    private func filterContentForSearchText(_ searchText: String) {
        filteredCountries = countries.filter { (country: Country) -> Bool in
            return country.name?.common?.lowercased().contains(searchText.lowercased()) ?? false
        }
        tableView.reloadData()
    }
    
    // MARK: - UI Setup
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Countries"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        let searchBar = searchController.searchBar
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.white
            textField.textColor = UIColor.black
            textField.leftView?.tintColor = UIColor.gray
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search Countries",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
        }
    }
    
    // MARK: - Alert Presentation
    private func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let country = isFiltering ? filteredCountries[indexPath.row] : countries[indexPath.row]
            let detailsVC = segue.destination as! DetailsViewController
            detailsVC.country = country
        }
    }
}
// MARK: - UITableViewDataSource
extension MainViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredCountries.count : countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableCell else {
            return UITableViewCell()
        }
        
        let country = isFiltering ? filteredCountries[indexPath.row] : countries[indexPath.row]
        cell.configure(with: country)
        return cell
    }
}

// MARK: - UISearchResultsUpdating
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text ?? "")
    }
}
