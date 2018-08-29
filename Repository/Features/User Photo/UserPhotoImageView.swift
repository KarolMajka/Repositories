//
//  UserPhotoImageView.swift
//  ZabZab
//
//  Created by Karol on 01/08/2018.
//  Copyright © 2018 ZAB ZAB Sp. z o.o. All rights reserved.
//

import UIKit
import Kingfisher

// MARK: -
class UserPhotoImageView: UIImageView {

    // MARK: Properties
    override var bounds: CGRect {
        didSet {
            updateBounds()
        }
    }

    // MARK: Initializations
    init() {
        super.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .scaleAspectFill
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentMode = .scaleAspectFill
    }

    // MARK: Methods
    func updateBounds() {
        guard bounds.width == bounds.height else { return }

        let radius = bounds.width / 2
        roundCorners([.allCorners], radius: radius)
    }
}
