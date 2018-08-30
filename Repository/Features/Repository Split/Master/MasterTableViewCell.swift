//
//  MasterTableViewCell.swift
//  Repository
//
//  Created by Karol on 29/08/2018.
//  Copyright © 2018 Karol Majka. All rights reserved.
//

import UIKit

// MARK: -
class MasterTableViewCell: UITableViewCell {

    // MARK: View Properties
    private(set) var userPhotoVC: UserPhotoViewController!
    private(set) var repositoryNameLabel: UILabel!
    private(set) var userNameLabel: UILabel!

    // MARK: Initializations
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods
    func update(repository: RepositoryModel) {
        repositoryNameLabel.text = repository.name
        userNameLabel.text = repository.ownerName
        userPhotoVC.stringURL = repository.ownerAvatarURL

        let fontWeight: UIFont.Weight = repository.serviceSource == .bitbucket ? .bold : .regular
        repositoryNameLabel.font = .systemFont(ofSize: 17, weight: fontWeight)
    }

    // MARK: Configuration
    private func configureViews() {
        let userPhotoVC: UserPhotoViewController = {
            let vc = UserPhotoViewController(stringUrl: nil)

            contentView.addSubview(vc.view)
            vc.view.translatesAutoresizingMaskIntoConstraints = false

            vc.view.widthAnchor.constraint(equalTo: vc.view.heightAnchor).isActive = true
            vc.view.widthAnchor.constraint(equalToConstant: 40).isActive = true
            vc.view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            vc.view.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true

            return vc
        }()
        self.userPhotoVC = userPhotoVC

        let repositoryNameLabel: UILabel = {
            let label = UILabel()

            contentView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false

            label.leftAnchor.constraint(equalTo: userPhotoVC.view.rightAnchor, constant: 16).isActive = true
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
            label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true

            return label
        }()
        self.repositoryNameLabel = repositoryNameLabel

        let userNameLabel: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14)
            label.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)

            contentView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false

            label.leftAnchor.constraint(equalTo: repositoryNameLabel.leftAnchor).isActive = true
            label.topAnchor.constraint(equalTo: repositoryNameLabel.bottomAnchor, constant: 1).isActive = true
            label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true

            return label
        }()
        self.userNameLabel = userNameLabel
    }
}

extension NSLayoutConstraint {
    func set(priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
