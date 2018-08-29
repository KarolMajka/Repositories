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

        if let repository = repository {
            update(repository: repository)
        } else {
            clear()
        }
    }

    private func update(repository: RepositoryModel) {
        repositoryNameLabel.text = repository.name
        ownerNameLabel.text = repository.ownerName
        descriptionTextView.text = repository.description
        userPhotoVC.stringURL = repository.ownerAvatarURL
    }

    private func clear() {
        repositoryNameLabel.text = ""
        ownerNameLabel.text = ""
        descriptionTextView.text = ""
        userPhotoVC.stringURL = ""
    }
}
