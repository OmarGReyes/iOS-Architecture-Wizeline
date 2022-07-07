//
//  SearchViewController.swift
//  iOSArchitecture
//
//  Created by Osmar Hernandez on 22/06/22.
//


import UIKit
import Combine

// MARK: SearchViewControllerDelegate
protocol SearchViewControllerDelegate: AnyObject {
    func addSongToFavorites(with song: Song)
}

// MARK: SearchViewController
final class SearchViewController: UIViewController {
    // MARK: - Properties
    private var viewModel: SearchSongViewModel!
    private var subscriptions = Set<AnyCancellable>()
    weak var delegate: SearchViewControllerDelegate?
    
    private var tableFooterView: UIView {
        let tableFooterView = UIView()
        tableFooterView.backgroundColor = .black
        return tableFooterView
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.insetsContentViewsToSafeArea = true
        tableView.contentInsetAdjustmentBehavior = .automatic
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search by song or artist"
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.tintColor = .white
        return searchController
    }()
    
    private lazy var rightBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Logout",
                                        style: .plain,
                                        target: self,
                                        action: #selector(logout))
        barButton.tintColor = .red
        return barButton
    }()
    
    // MARK: - Initializer
    convenience init(viewModel: SearchSongViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupTableView()
        setupNavigationItem()
        bind()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: - Methods
    // MARK: setupTableView
    private func setupTableView() {
        tableView.register(SongCell.self, forCellReuseIdentifier: SongCell.reuseIdentifier)
        tableView.register(AlbumCell.self, forCellReuseIdentifier: AlbumCell.reuseIdentifier)
        tableView.register(HeaderCell.self, forHeaderFooterViewReuseIdentifier: HeaderCell.reuseIdentifier)
    }
    
    // MARK: setupNavigationItem
    private func setupNavigationItem() {
        navigationItem.title = "Welcome!"
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    // MARK: bind
    private func bind() {
        viewModel
            .$sections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }.store(in: &subscriptions)
    }
    
    // MARK: logout
    @objc private func logout() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: displayAlbumAlert
    private func displayAlbumAlert() {
        let alert: UIAlertController = UIAlertController(title: "Stop",
                                                         message: "Working with MVVM is great",
                                                         preferredStyle: .alert)
        let accept: UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(accept)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: displaySaveAlert
    private func displaySaveAlert(with song: Song) {
        let alert: UIAlertController = UIAlertController(title: "Add to favorites",
                                                         message: "Do you wanna add this song to favorites?",
                                                         preferredStyle: .alert)
        let acceptAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            self?.delegate?.addSongToFavorites(with: song)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchTerm = searchBar.text ?? ""
        searchController.dismiss(animated: true) { [weak viewModel] in
            viewModel?.songInput = searchTerm
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.songInput = ""
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard ((viewModel.sections?[indexPath.section].items[indexPath.row] as? SongCellModel) != nil) else {
            displayAlbumAlert()
            return
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections?[section].items.count ?? Int.zero
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections?.count ?? Int.zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentObject: DataCellViewModable = viewModel.sections?[indexPath.section].items[indexPath.row],
              let currentCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: currentObject.reuseIdentifier) else {
                  let cell: UITableViewCell = UITableViewCell()
                  return cell
              }
        
        (currentCell as? CustomConfigurableCell)?.setup(with: currentObject)
        (currentCell as? SongCell)?.delegate = self
        return currentCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionTitle : String = viewModel.sections?[section].title,
              let sectionView: HeaderCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderCell.reuseIdentifier) as? HeaderCell
        else { return  nil }
        
        sectionView.setup(text: sectionTitle)
        return sectionView
    }
}

// MARK: - SongCellDelegate
extension SearchViewController: SongCellDelegate {
    func didTapMoreButton(with song: Song) {
        displaySaveAlert(with: song)
    }
}
