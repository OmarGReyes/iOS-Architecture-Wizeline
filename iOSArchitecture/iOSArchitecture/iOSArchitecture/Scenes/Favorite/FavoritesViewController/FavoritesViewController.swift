//
//  FavoritesViewController.swift
//  iOSArchitecture
//
//  Created by Omar Gonzalez on 4/07/22.
//

import UIKit
import Combine

// MARK: FavoritesViewController
final class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: FavoritesViewModel!
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Initializer
    convenience init(viewModel: FavoritesViewModel) {
        self.init()
        self.viewModel = viewModel
    }
   
    // MARK: - Private properties
    private lazy var tableFooterView: UIView = {
        let tableFooterView = UIView()
        tableFooterView.backgroundColor = .black
        return tableFooterView
    }()
    
    private lazy var rightBarButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Logout",
                                        style: .plain,
                                        target: self,
                                        action: #selector(logout))
        barButton.tintColor = .red
        return barButton
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.insetsContentViewsToSafeArea = true
        tableView.contentInsetAdjustmentBehavior = .automatic
        return tableView
    }()
    
    // MARK: - Lifecycle methods
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        navigationController?.navigationItem.title = "Favorites"
        setupTableView()
        setupNavigationItem()
        bind()
    }
    
    // MARK: - Private methods
    private func setupTableView() {
        tableView.register(SongCell.self, forCellReuseIdentifier: SongCell.reuseIdentifier)
        tableView.register(HeaderCell.self, forHeaderFooterViewReuseIdentifier: HeaderCell.reuseIdentifier)
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "Favorites!"
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func bind() {
        viewModel
            .$sections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }.store(in: &subscriptions)
    }
    
    @objc private func logout() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
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
}

// MARK: - SongCellDelegate
extension FavoritesViewController: SongCellDelegate {
    func didTapMoreButton(with song: Song) {
        displaySaveAlert(with: song)
    }
}

// MARK: - FavoritesViewController + Alerts
extension FavoritesViewController {
    private func displayDeleteAlert() {
        let alert: UIAlertController = UIAlertController(title: "Remove this song from favorites",
                                                         message: "Do you wanna delete this song to favorites?",
                                                         preferredStyle: .alert)
        let acceptAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    private func displaySaveAlert(with song: Song) {
        let alert: UIAlertController = UIAlertController(title: "Delete song",
                                                         message: "Do you wanna this this song from favorites?",
                                                         preferredStyle: .alert)
        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .default, handler: { [weak self] _ in
            self?.viewModel.deleteSong(songToDelete: song)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
