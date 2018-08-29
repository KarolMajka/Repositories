//
//  UserPhotoViewController.swift
//  ZabZab
//
//  Created by Karol on 08/08/2018.
//  Copyright © 2018 ZAB ZAB Sp. z o.o. All rights reserved.
//

import UIKit
import Kingfisher

// MARK: -
class UserPhotoViewController: UIViewController {

    // MARK: Properties
    var url: URL? {
        didSet {
            if url != oldValue {
                updateImage(url: url)
            }
        }
    }
    var stringURL: String {
        get {
            return url?.absoluteString ?? ""
        }
        set {
            url = URL(string: newValue)
        }
    }
    var placeholderImage = #imageLiteral(resourceName: "ic_user_placeholder")

    // MARK: View Properties
    private(set) var imageView: UserPhotoImageView!

    // MARK: Initializations
    init(url: URL?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(stringUrl: String?) {
        let stringUrl = stringUrl ?? ""
        let url = URL(string: stringUrl)
        self.init(url: url)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: View Life Cycle
    override func loadView() {
        let imageView = UserPhotoImageView()
        self.imageView = imageView
        self.view = imageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateImage(url: url)
    }

    // MARK: Methods
    func redownloadImage() {
        updateImage(url: url)
    }

    // MARK: Private Methods
    private func updateImage(url: URL?) {
        imageView.kf.setImage(with: url, placeholder: placeholderImage)
    }
}
