//
//  MasterViewController.swift
//  Repository
//
//  Created by Karol on 28/08/2018.
//  Copyright © 2018 Karol Majka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: -
class MasterViewController: UIViewController {

    // MARK: Properties
    private static let segueDetailIdentifier = "showDetailSegue"
    private let viewModel = MasterViewModel(repositoryService: RepositoryService(gitHubService: RepositoryGitHubService(), bitbucketService: RepositoryBitbucketService()), realmManager: RealmManager())
    private let disposeBag = DisposeBag()

    // MARK: IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var sortBarButtonItem: UIBarButtonItem!
    let refreshControl = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)

    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(MasterTableViewCell.self)
        tableView.refreshControl = refreshControl

        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController

        configureRx()

        viewModel.loadCachedData()
        viewModel.loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let splitViewController = splitViewController, splitViewController.isCollapsed, let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case MasterViewController.segueDetailIdentifier?:
            guard let repository = sender as? RepositoryModel, let detailVC = (segue.destination as? UINavigationController)?.topViewController as? DetailViewController else { fatalError() }
            detailVC.repository = repository
        default:
            break
        }
    }

    // MARK: Private Methods
    private func present(error: Error) {
        guard presentedViewController == nil else { return }
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: Configuration
    private func configureRx() {
        configureTableDataSource()
        configureTableViewSelected()
        configureSortTap()
        configureTableViewRefresh()
        configureErrorHandling()
        configureSearch()
    }

    private func configureTableDataSource() {
        viewModel.dataSource.drive(tableView.rx.items(cellIdentifier: MasterTableViewCell.reuseIdentifier, cellType: MasterTableViewCell.self)) { (_, repository, cell) in
            cell.update(repository: repository)
        }.disposed(by: disposeBag)
    }

    private func configureTableViewSelected() {
        tableView.rx.modelSelected(RepositoryModel.self).bind { [weak self] in
            self?.performSegue(withIdentifier: MasterViewController.segueDetailIdentifier, sender: $0)
        }.disposed(by: disposeBag)
    }

    private func configureSortTap() {
        sortBarButtonItem.rx.tap.map { [viewModel] _ in viewModel.repositoryFilterOptions.value.sortOrder }.map {
            switch $0 {
            case .ascending:
                return .descending
            case .descending:
                return .none
            case .none:
                return .ascending
            }
        }.bind(onNext: { [viewModel] in viewModel.repositoryFilterOptions.value.sortOrder = $0 }).disposed(by: disposeBag)
    }

    private func configureTableViewRefresh() {
        refreshControl.rx.controlEvent(.valueChanged).map { [refreshControl] in !refreshControl.isRefreshing }.bind(onNext: { [viewModel] _ in viewModel.loadData() }).disposed(by: disposeBag)

        refreshControl.rx.controlEvent(.valueChanged).map { [refreshControl] in refreshControl.isRefreshing }.bind(onNext: { [refreshControl] _ in refreshControl.endRefreshing() }).disposed(by: disposeBag)
    }

    private func configureErrorHandling() {
        viewModel.onFailure.bind(onNext: { [weak self] in self?.present(error: $0) }).disposed(by: disposeBag)
    }

    private func configureSearch() {
        searchController.searchBar.rx.text.orEmpty.asObservable().bind(onNext: { [viewModel] in viewModel.repositoryFilterOptions.value.filterText = $0 }).disposed(by: disposeBag)

        searchController.searchBar.rx.cancelButtonClicked.bind(onNext: { [viewModel] in viewModel.repositoryFilterOptions.value.filterText = "" }).disposed(by: disposeBag)
    }
}
