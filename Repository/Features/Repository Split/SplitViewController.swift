//
//  SplitViewController.swift
//  Repository
//
//  Created by Karol on 29/08/2018.
//  Copyright © 2018 Karol Majka. All rights reserved.
//

import UIKit
import RxSwift

// MARK: -
class SplitViewController: UISplitViewController {

    private let disposeBag = DisposeBag()

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredDisplayMode = .allVisible
        delegate = self
    }
}

// MARK: UISplitViewControllerDelegate
extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        guard let detailVC = (secondaryViewController as? UINavigationController)?.topViewController as? DetailViewController else { return true }
        return detailVC.repository == nil
    }
}
