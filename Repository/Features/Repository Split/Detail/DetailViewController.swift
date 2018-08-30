//
//  DetailViewController.swift
//  Repository
//
//  Created by Karol on 28/08/2018.
//  Copyright © 2018 Karol Majka. All rights reserved.
//

import UIKit

// MARK: -
class DetailViewController: UIViewController {

    // MARK: Properties
    var repository: RepositoryModel?

    // MARK: IBOutlets
    @IBOutlet var repositoryNameLabel: UILabel!
    @IBOutlet var ownerNameLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!

    lazy var userPhotoVC: UserPhotoViewController = {
        return childViewControllers.first { $0 is UserPhotoViewController } as! UserPhotoViewController // swiftlint:disable:this force_cast
    }()

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        updateRepository()
    }

    // MARK: Private Methods
    private func updateRepository() {
        if let repository = repository {
            update(repository: repository)
        } else {
            clear()
        }
    }

    private func update(repository: RepositoryModel) {
        title = repository.name
        repositoryNameLabel.text = repository.name
        ownerNameLabel.text = repository.ownerName
        descriptionTextView.text = repository.description
        userPhotoVC.stringURL = repository.ownerAvatarURL

        let fontWeight: UIFont.Weight = repository.serviceSource == .bitbucket ? .bold : .regular
        repositoryNameLabel.font = .systemFont(ofSize: 17, weight: fontWeight)
    }

    private func clear() {
        title = ""
        repositoryNameLabel.text = ""
        ownerNameLabel.text = ""
        descriptionTextView.text = ""
        userPhotoVC.stringURL = ""
    }
}
