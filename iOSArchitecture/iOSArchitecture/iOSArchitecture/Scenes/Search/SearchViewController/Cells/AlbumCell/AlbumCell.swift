//
//  AlbumCell.swift
//  iOSArchitecture
//
//  Created by Omar Gonzalez on 2/07/22.
//

import UIKit

// MARK: AlbumCell
final class AlbumCell: UITableViewCell, CustomConfigurableCell {

    // MARK: - Properties
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    // MARK: setupUI
    private func setupUI() {
        contentView.backgroundColor = .black
        contentView.addSubview(nameLabel)
        activateNameLabelConstraints()
    }
    
    // MARK: activateNameLabelConstraints
    private func activateNameLabelConstraints() {
        let leading = nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8)
        let centerY = nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        NSLayoutConstraint.activate([leading,centerY])
    }
    
    // MARK: setup
    func setup(with data: DataCellViewModable) {
        guard let album = data as? AlbumCellModel else { return }
        nameLabel.text = album.albumName
    }
}
